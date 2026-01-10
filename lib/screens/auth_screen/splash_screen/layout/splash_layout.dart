import '../../../../config.dart';
import '../../../../helper/auth_helper.dart';
import '../../../../api/api_client.dart';
import '../../../../api/services/auth_service.dart';

class SplashLayout extends StatefulWidget {
  const SplashLayout({super.key});

  @override
  State<SplashLayout> createState() => _SplashLayoutState();
}

class _SplashLayoutState extends State<SplashLayout> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authService = AuthService(ApiClient());
    final response = await authService.verifyToken();

    if (!mounted) return;

    // User is logged in, go directly to dashboard
    if (response.success && response.tokenValid == true) {
      Navigator.pushReplacementNamed(context, routeName.dashBoardLayout);
    } else {
      // Token invalid, clear auth and go to splash
      await AuthHelper.logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, routeName.signInScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColor(context).appTheme.screenBg,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(
            svgAssets.logo,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 30),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                appColor(context).appTheme.primary),
          )
        ])));
  }
}
