import 'package:skolo/config.dart';
import 'package:skolo/screens/app_pages/notification/notification_widgets.dart';
import '../../../widgets/auto_refresh_mixin.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutoRefreshMixin {
  @override
  void refreshData() {
    context.read<NotificationProvider>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColor(context).appTheme.screenBg,
        body: Consumer<NotificationProvider>(
            builder: (context, notificationCtrl, child) {
          return Column(children: [
            Row(children: [
              HSpace(Sizes.s20),
              CommonIconButton(
                  icon: svgAssets.back,
                  bgColor: appColor(context).appTheme.bgBox,
                  onTap: () => route.pop(context)),
              HSpace(Sizes.s70),
              TextWidgetCommon(
                  text: appFonts.notification,
                  style: AppCss.lexendMedium18
                      .textColor(appColor(context).appTheme.darkText)),
            ]).padding(top: Sizes.s50, bottom: Sizes.s20),
            Expanded(
              child: notificationCtrl.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notificationCtrl.notifications.isEmpty
                      ? Center(
                          child: TextWidgetCommon(
                              text: 'No notifications yet',
                              style: AppCss.lexendRegular14.textColor(
                                  appColor(context).appTheme.lightText)))
                      : RefreshIndicator(
                          onRefresh: () =>
                              notificationCtrl.fetchNotifications(),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: notificationCtrl.notifications.length,
                            itemBuilder: (context, index) {
                              final notif =
                                  notificationCtrl.notifications[index];
                              final e = {
                                'title': notif.title ?? '',
                                'subtitle': notif.message ?? '',
                                'icon': _getIconForType(notif.notificationType),
                                'isRead': notif.isRead,
                              };
                              return Row(children: [
                                NotificationWidgets().titleSubtitle(e, context),
                                HSpace(Sizes.s6),
                                NotificationWidgets().iconLayout(e, context),
                              ])
                                  .padding(
                                      vertical: Sizes.s15,
                                      horizontal: Sizes.s15)
                                  .width(MediaQuery.of(context).size.width)
                                  .notificationExtension(context, e)
                                  .padding(
                                      bottom: Sizes.s15, horizontal: Sizes.s15);
                            },
                          ),
                        ),
            ),
          ]);
        }));
  }

  String _getIconForType(String? type) {
    switch (type) {
      case 'picked_up':
        return svgAssets.car;
      case 'dropped':
        return svgAssets.location;
      case 'approaching':
        return svgAssets.bell;
      case 'absent':
        return svgAssets.alert;
      case 'trip_started':
        return svgAssets.driving;
      case 'trip_completed':
        return svgAssets.check;
      case 'payment_due':
        return svgAssets.dollarCircle;
      default:
        return svgAssets.alert;
    }
  }
}
