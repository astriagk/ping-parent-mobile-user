import '../../../../config.dart';

//select option layout
class SelectOptionLayout extends StatelessWidget {
  const SelectOptionLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OutStationProvider>(builder: (context, outCtrl, child) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: outCtrl.selectOption
                      .asMap()
                      .entries
                      .map(
                          (e) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                    SvgPicture.asset(svgAssets.infoCircle),
                                    Image.asset(e.value['image'],
                                            height: Sizes.s48,
                                            fit: BoxFit.contain)
                                        .center()
                                        .padding(vertical: Sizes.s9),
                                    TextWidgetCommon(
                                            style: AppCss.lexendMedium12,
                                            text: e.value['title'],
                                            fontSize: Sizes.s12,
                                            fontWeight: FontWeight.w500)
                                        .center()
                                  ])
                                  .inkWell(
                                      onTap: () =>
                                          outCtrl.setSelectedOptionIndex(e.key))
                                  .paddingDirectional(all: Sizes.s10)
                                  .width(Sizes.s102)
                                  .decorated(
                                      color: appColor(context).appTheme.white,
                                      allRadius: Sizes.s12,
                                      sideColor: outCtrl.selectedOptionIndex ==
                                              e.key
                                          ? appColor(context).appTheme.primary
                                          : appColor(context).appTheme.stroke)
                                  .padding(
                                      vertical: Sizes.s2,
                                      horizontal:
                                          e.key == 1 ? Sizes.s12 : Sizes.s0))
                      .toList())
              .paddingDirectional(horizontal: Sizes.s20, bottom: Sizes.s15));
    });
  }
}
