import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/provider/app_pages_providers/user_provider.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final name = userProvider.userData?.name ?? '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VSpace(Sizes.s16),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Welcome, ',
                  style: AppCss.lexendBold24
                      .textColor(appColor(context).appTheme.darkText),
                ),
                TextSpan(
                  text: name.isNotEmpty ? name : 'Hello!',
                  style: AppCss.lexendBold24
                      .textColor(appColor(context).appTheme.darkText),
                ),
              ]),
            ),
            VSpace(Sizes.s6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.gps_fixed, size: Sizes.s14, color: appColor(context).appTheme.primary),
                  HSpace(Sizes.s8),
                  Expanded(
                    child: TextWidgetCommon(
                      text: 'Parents can track their kids live while travelling',
                      style: AppCss.lexendRegular13
                          .textColor(appColor(context).appTheme.hintText),
                    ),
                  )
                ]),
                VSpace(Sizes.s6),
                Row(children: [
                  Icon(Icons.check_circle_outline, size: Sizes.s14, color: appColor(context).appTheme.primary),
                  HSpace(Sizes.s8),
                  Expanded(
                    child: TextWidgetCommon(
                      text: 'View attendance and pick/drop status',
                      style: AppCss.lexendRegular13
                          .textColor(appColor(context).appTheme.hintText),
                    ),
                  )
                ]),
                VSpace(Sizes.s6),
                Row(children: [
                  Icon(Icons.event, size: Sizes.s14, color: appColor(context).appTheme.primary),
                  HSpace(Sizes.s8),
                  Expanded(
                    child: TextWidgetCommon(
                      text: 'See school activities and announcements',
                      style: AppCss.lexendRegular13
                          .textColor(appColor(context).appTheme.hintText),
                    ),
                  )
                ]),
                VSpace(Sizes.s6),
                Row(children: [
                  Icon(Icons.celebration, size: Sizes.s14, color: appColor(context).appTheme.primary),
                  HSpace(Sizes.s8),
                  Expanded(
                    child: TextWidgetCommon(
                      text: 'Cultural events and much more',
                      style: AppCss.lexendRegular13
                          .textColor(appColor(context).appTheme.hintText),
                    ),
                  )
                ]),
              ],
            ),
            VSpace(Sizes.s16),
          ],
        );
      },
    );
  }
}
