import '../../../../config.dart';

class ChooseRiderList extends StatelessWidget {
  final dynamic e;
  final int? chooseRider;

  const ChooseRiderList({super.key, this.e, this.chooseRider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          SvgPicture.asset(e.value['icon']),
          HSpace(Sizes.s6),
          TextWidgetCommon(
              text: e.value['title'],
              color: e.value["title"] == appFonts.mySelf
                  ? appColor(context).appTheme.darkText
                  : appColor(context).appTheme.yellowIcon)
        ]),
        e.value["title"] == appFonts.mySelf
            ? Container(
                width: Sizes.s20,
                height: Sizes.s20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColor(context)
                        .appTheme
                        .primary
                        .withValues(alpha: 0.12)),
                child: Icon(Icons.circle,
                    color: appColor(context).appTheme.primary, size: Sizes.s13))
            : SvgPicture.asset(svgAssets.arrowRightYellow),
      ]).inkWell(onTap: () {
        if (e.key == 1) {
          route.pop(context);
          route.pushNamed(context, routeName.chooseRiderScreen);
        }
      }).padding(
          top: e.key == 1 ? Sizes.s20 : Sizes.s30,
          bottom: e.key == 1 ? Sizes.s30 : Sizes.s20),
      if (e.key != chooseRider! - 1)
        Divider(color: appColor(context).appTheme.bgBox, height: 0),
    ]);
  }
}
