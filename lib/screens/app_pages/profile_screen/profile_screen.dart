import '../../../config.dart';
import '../../../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // Prevent phone field from gaining focus
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        _emailFocusNode.requestFocus();
      }
    });

    // Populate controllers with existing user data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.userData != null) {
        _updateControllers(userProvider.userData!);
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
    if (_isUpdating) return;

    setState(() => _isUpdating = true);

    final userProvider = context.read<UserProvider>();

    final success = await userProvider.updateUserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (mounted) {
      setState(() => _isUpdating = false);

      if (success) {
        // Update controllers with new data
        _updateControllers(userProvider.userData!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: TextWidgetCommon(text: 'Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidgetCommon(
              text: userProvider.errorMessage ?? 'Failed to update profile',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final profileData = userProvider.userData;

        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: appColor(context).appTheme.white,
            appBar: CommonAppBarLayout(
                title: appFonts.profileSetting, radius: Sizes.s20),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //profile image and edit button layout
                        ProfileWidgets().profileImageLayout(context,
                            photoUrl: profileData?.photoUrl),
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
                      ]).padding(horizontal: Sizes.s20).authExtension(context),
                  CommonButton(
                          text: _isUpdating
                              ? appFonts.updatingProfile
                              : appFonts.updateProfile,
                          onTap: _isUpdating ? null : _updateProfile)
                      .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                ]));
      },
    );
  }
}
