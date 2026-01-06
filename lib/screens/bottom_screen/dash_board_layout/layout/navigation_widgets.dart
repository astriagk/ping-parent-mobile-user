
import '../../../../config.dart';

class NavigationBarWidgets {
  Widget buildNavItem(BuildContext context) {
    // Define colors for icons and text
    Color defaultTextColor = appColor(context).appTheme.lightText;
    Color selectedTextColor = appColor(context).appTheme.primary;

    return Consumer2<DashBoardProvider, LanguageProvider>(
        builder: (context1, bottomCtrl, languageCtrl, child) {
      return StatefulBuilder(builder: (context1, setState) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bottomCtrl.bottomNavigationBarList
                .asMap()
                .entries
                .map((entries) {
              var e = entries.value;
              var index = entries.key;
              // Determine color based on the current tab
              return Row(children: [
                InkWell(
                    radius: Sizes.s10,
                    focusColor: appColor(context).appTheme.trans,
                    highlightColor: appColor(context).appTheme.trans,
                    onTap: () => bottomCtrl.tabChange(index),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
                      bottomCtrl.currentTab == index
                          ? SvgPicture.asset(e['iconDark'])
                          : SvgPicture.asset(e['icon']),
                      VSpace(Sizes.s2),
                      TextWidgetCommon(
                              text: e['title'],
                             style: AppCss.lexendRegular14.textColor(bottomCtrl.currentTab == index
                                 ? selectedTextColor
                                 : defaultTextColor),
                              overflow: TextOverflow.ellipsis).center()
                    ])),

              ]);
            }).toList());
      });
    });
  }


}
