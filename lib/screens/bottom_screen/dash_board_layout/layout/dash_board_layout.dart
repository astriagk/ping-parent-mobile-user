import 'package:flutter/services.dart';
import '../../../../config.dart';

// bottom navigation Bar layout
class DashBoardLayout extends StatelessWidget {
  const DashBoardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardProvider>(builder: (context1, bottomCtrl, child) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          SystemNavigator.pop();
        },
        child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: appColor(context)
                          .appTheme
                          .primary
                          .withValues(alpha: 0.03),
                      blurRadius: 20,
                      spreadRadius: 7)
                ],
                borderRadius: BorderRadius.circular(Sizes.s20),
                border: Border(
                    top: BorderSide(
                        color: appColor(context).appTheme.borderColor,
                        width: 1))),
            child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Sizes.s20),
                    topRight: Radius.circular(Sizes.s20)),
                child: BottomAppBar(
                    shadowColor: appColor(context).appTheme.primary,
                    color: appColor(context).appTheme.white,
                    height: Sizes.s70,
                    elevation: Sizes.s50,
                    child: NavigationBarWidgets().buildNavItem(context)))),
      );
    });
  }
}
