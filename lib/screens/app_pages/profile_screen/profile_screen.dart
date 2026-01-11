import '../../../config.dart';
import '../../../api/api_client.dart';
import '../../../api/services/user_service.dart';
import '../../../api/models/profile_response.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService(ApiClient());
  ProfileData? profileData;
  bool isLoading = true;
  bool isUpdating = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    // Prevent phone field from gaining focus
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        _emailFocusNode.requestFocus();
      }
    });
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

  Future<void> _fetchProfile() async {
    try {
      setState(() => isLoading = true);
      final response = await _userService.getParentProfile();
      if (response.success && response.data != null) {
        setState(() {
          profileData = response.data;
          _nameController.text = profileData?.name ?? '';
          _emailController.text = profileData?.email ?? '';
          _phoneController.text = profileData?.user.phoneNumber ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: TextWidgetCommon(text: 'Failed to load profile')),
          );
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidgetCommon(text: 'Error: $e')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      setState(() => isUpdating = true);

      final response = await _userService.updateParentProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (response.success && response.data != null) {
        setState(() {
          profileData = response.data;
          isUpdating = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: TextWidgetCommon(text: response.message)),
          );
        }
      } else {
        setState(() => isUpdating = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: TextWidgetCommon(text: 'Failed to update profile')),
          );
        }
      }
    } catch (e) {
      setState(() => isUpdating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidgetCommon(text: 'Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColor(context).appTheme.white,
        appBar: CommonAppBarLayout(
            title: appFonts.profileSetting, radius: Sizes.s20),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                        ])
                        .padding(horizontal: Sizes.s20)
                        .authExtension(context),
                    CommonButton(
                            text: appFonts.updateProfile,
                            onTap: isUpdating ? null : _updateProfile)
                        .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                  ]));
  }
}
