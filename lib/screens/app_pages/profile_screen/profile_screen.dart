import 'package:skolo/config.dart';
import 'package:skolo/provider/app_pages_providers/user_provider.dart';
import 'package:skolo/widgets/auto_refresh_mixin.dart';
import 'package:skolo/widgets/skeletons/profile_screen_skeleton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutoRefreshMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void refreshData() {
    final userProvider = context.read<UserProvider>();
    userProvider.fetchUserProfile().then((_) {
      if (mounted && userProvider.userData != null) {
        _updateControllers(userProvider.userData!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Prevent phone field from gaining focus
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        _emailFocusNode.requestFocus();
      }
    });
  }

  void _updateControllers(profileData) {
    _nameController.text = profileData.name ?? '';
    _emailController.text = profileData.email ?? '';
    _phoneController.text = profileData.user.phoneNumber ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final userProvider = context.read<UserProvider>();

    if (userProvider.isUpdating) return;

    final success = await userProvider.updateUserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (mounted) {
      if (success) {
        AppSnackBar.success(context, 'Profile updated successfully');
        route.pop(context);
      } else {
        AppSnackBar.error(context, userProvider.errorMessage ?? 'Failed to update profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final profileData = userProvider.userData;

        return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: appColor(context).appTheme.white,
            appBar: CommonAppBarLayout(
                title: appFonts.profileSetting, radius: Sizes.s20),
            body: userProvider.isFetching
                ? const ProfileScreenSkeleton()
                : Column(children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              //profile image and edit button layout
                              ProfileWidgets().profileImageLayout(context,
                                  photoUrl: profileData?.photoUrl,
                                  selectedImageFile:
                                      userProvider.selectedProfileImage,
                                  onPickFromGallery:
                                      userProvider.pickProfileImageFromGallery,
                                  onPickFromCamera:
                                      userProvider.pickProfileImageFromCamera),
                              Divider(
                                      color: appColor(context).appTheme.stroke,
                                      height: 0)
                                  .padding(top: Sizes.s25, bottom: Sizes.s20),
                              //common title and text-field layout
                              ProfileWidgets().commonTextField(context,
                                  title: appFonts.userName,
                                  hintText: appFonts.enterYourName,
                                  controller: _nameController),
                              //common title and text-field layout
                              ProfileWidgets().commonTextField(context,
                                  title: appFonts.mobileNumber,
                                  hintText: appFonts.enterYourNumber,
                                  textInputType: TextInputType.number,
                                  controller: _phoneController,
                                  focusNode: _phoneFocusNode,
                                  readOnly: true),
                              //common title and text-field layout
                              ProfileWidgets().commonTextField(context,
                                  title: appFonts.email,
                                  hintText: appFonts.enterYourEmailId,
                                  focusNode: _emailFocusNode,
                                  controller: _emailController)
                            ])
                            .padding(horizontal: Sizes.s20)
                            .authExtension(context),
                      ),
                    ),
                    CommonButton(
                            text: appFonts.updateProfile,
                            isLoading: userProvider.isUpdating,
                            onTap: _updateProfile)
                        .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                  ]));
      },
    );
  }
}
