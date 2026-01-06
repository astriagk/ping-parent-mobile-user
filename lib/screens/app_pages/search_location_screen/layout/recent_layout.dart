import '../../../../config.dart';

class RecentLayout extends StatelessWidget {
  const RecentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchLocationProvider>(
        builder: (context, searchCtrl, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextWidgetCommon(
                text: "Recent",
                fontSize: Sizes.s18,
                fontWeight: FontWeight.w400)
            .padding(bottom: Sizes.s15),
        ...searchCtrl.recentLocationList
            .asMap()
            .entries
            .map((e) => Column(children: [
                  Row(children: [
                    SvgPicture.asset(svgAssets.history)
                        .padding(all: Sizes.s7)
                        .decorated(
                            color: appColor(context).appTheme.bgBox,
                            shape: BoxShape.circle,
                            allRadius: Sizes.s20),
                    HSpace(Sizes.s10),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          TextWidgetCommon(text: e.value['area']),
                          VSpace(Sizes.s3),
                          TextWidgetCommon(
                              text: e.value['address'],
                              fontSize: Sizes.s12,
                              fontWeight: FontWeight.w300,
                              color: appColor(context).appTheme.lightText)
                        ]))
                  ]).inkWell(
                      onTap: () => route.pushNamed(
                          context, routeName.selectRiderScreen)),
                  if (e.key != searchCtrl.recentLocationList.length - 1)
                    Divider(color: appColor(context).appTheme.bgBox, height: 0)
                        .padding(vertical: Sizes.s15)
                ]))
      ]);
    });
  }
}
