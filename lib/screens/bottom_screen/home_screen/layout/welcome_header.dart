import 'package:skolo/config.dart';
import 'package:skolo/provider/app_pages_providers/user_provider.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final name = userProvider.userData?.name ?? '';
        final firstName = name.isNotEmpty ? name.split(' ').first : 'there';

        return Padding(
          padding: EdgeInsets.only(top: Sizes.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgetCommon(
                text: _greeting,
                style: AppCss.lexendRegular13
                    .textColor(appColor(context).appTheme.hintText),
              ),
              VSpace(Sizes.s2),
              TextWidgetCommon(
                text: firstName,
                style: AppCss.lexendBold24
                    .textColor(appColor(context).appTheme.darkText),
              ),
            ],
          ),
        );
      },
    );
  }
}
