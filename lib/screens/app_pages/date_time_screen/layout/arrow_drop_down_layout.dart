import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/widgets/common_arrow.dart';

class ArrowDropDownLayout extends StatelessWidget {
  final dynamic setState;
  final double? hSpace;

  const ArrowDropDownLayout(this.setState, {super.key, this.hSpace});

  @override
  Widget build(BuildContext context) {
    return Consumer<DateTimeProvider>(builder: (context, dateTimePvr, child) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CommonArrow(
            arrow: svgAssets.arrowLeft, onTap: () => dateTimePvr.onLeftArrow()),
        Container(
            height: Sizes.s34,
            alignment: Alignment.center,
            width: Sizes.s100,
            child: DropdownButton(
                underline: Container(),
                focusColor: Colors.white,
                value: dateTimePvr.chosenValue,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: appArray.monthList.map<DropdownMenuItem>((monthValue) {
                  return DropdownMenuItem(
                      value: monthValue,
                      child: TextWidgetCommon(
                          text: monthValue['title'],
                          style: AppCss.lexendLight14
                              .textColor(appColor(context).appTheme.darkText)));
                }).toList(),
                icon: SvgPicture.asset(svgAssets.dropDown),
                onChanged: (choseVal) {
                  dateTimePvr.onDropDownChange(choseVal);
                  setState;
                })).boxShapeExtension(
            context: context,
            color: appColor(context).appTheme.white,
            radius: AppRadius.r4),
        Container(
                alignment: Alignment.center,
                height: Sizes.s34,
                width: Sizes.s87,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextWidgetCommon(
                          text: "${dateTimePvr.selectedYear.year}",
                          style: AppCss.lexendLight14
                              .textColor(appColor(context).appTheme.darkText)),
                      SvgPicture.asset(svgAssets.dropDown)
                    ]))
            .boxShapeExtension(
                context: context,
                color: appColor(context).appTheme.white,
                radius: AppRadius.r4)
            .inkWell(onTap: () => dateTimePvr.selectYear(context)),
        CommonArrow(
            arrow: svgAssets.arrowRight,
            onTap: () => dateTimePvr.onRightArrow())
      ]).paddingSymmetric(horizontal: hSpace ?? Insets.i20);
    });
  }
}
