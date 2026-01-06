import '../../../../config.dart';

class SearchLocationWidgets {
  //addHome and addWork Layout
  Widget homeWorkRowLayout() =>
      Consumer<SearchLocationProvider>(builder: (context, searchCtrl, child) {
        return IntrinsicHeight(
            child: Row(children: [
          ...searchCtrl.workHomeList.map((e) => Row(children: [
                SvgPicture.asset(e['icon']).padding(all: Sizes.s8).decorated(
                    color: appColor(context).appTheme.bgBox,
                    shape: BoxShape.circle,
                    allRadius: Sizes.s20),
                HSpace(Sizes.s10),
                TextWidgetCommon(text: e['title']),
                VerticalDivider(
                        width: 1, color: appColor(context).appTheme.bgBox)
                    .padding(horizontal: Sizes.s15, vertical: Sizes.s8),
              ]).inkWell(
                  onTap: () =>
                      route.pushNamed(context, routeName.addLocationScreen)))
        ])).padding(vertical: Sizes.s25);
      });

  //add new TextField layout
  Widget addTextFieldLayout() =>
      Consumer<SearchLocationProvider>(builder: (context, searchCtrl, child) {
        return Expanded(
            child: Column(children: [
          TextField(
              decoration: InputDecoration(
                  hintText: appFonts.pickupLocation,
                  hintStyle:
                      AppCss.lexendLight14.textColor(appTheme.darkText))),
          ...searchCtrl.getTextFieldData(context)
        ]));
      });

  //add icon with TextField layout
  Widget addIconLayout() =>
      Consumer<SearchLocationProvider>(builder: (context, searchCtrl, child) {
        return Column(children: [
          SvgPicture.asset(svgAssets.locationSearch,
              height: Sizes.s20, width: Sizes.s20, fit: BoxFit.fill),
          ...searchCtrl.textFieldList
              .asMap()
              .entries
              .map((e) => Column(children: [
                    Dash(
                        length: 28,
                        dashGap: 1,
                        dashThickness: 2,
                        dashBorderRadius: 3,
                        direction: Axis.vertical,
                        dashColor: appColor(context).appTheme.lightText),
                    Stack(children: [
                      SvgPicture.asset(
                          e.key == searchCtrl.textFieldList.length - 1
                              ? svgAssets.gpsDestination
                              : svgAssets.addDestination,
                          height: Sizes.s18,
                          width: Sizes.s18,
                          fit: BoxFit.fill),
                      if (e.key != searchCtrl.textFieldList.length - 1)
                        TextWidgetCommon(
                                text: '${e.key + 1}',
                                color: appColor(context).appTheme.white,
                                fontSize: Sizes.s14)
                            .padding(horizontal: Sizes.s5, vertical: Sizes.s1)
                    ])
                  ]))
        ]).padding(vertical: Sizes.s15);
      });
}
