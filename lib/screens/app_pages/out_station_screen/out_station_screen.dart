import 'package:taxify_user_ui/config.dart';

class OutStationScreen extends StatelessWidget {
  const OutStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SearchLocationProvider, OutStationProvider>(
        builder: (context, searchCtrl, outCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150).then((value) {
                outCtrl.onInit();
                searchCtrl.onInit();
              }),
          child: Scaffold(
              body: Column(children: [
            const AppBarAndAddLocationLayout(),
            Expanded(
                child: ListView(padding: EdgeInsets.zero, children: [
              OutStationWidgets()
                  .faresDoNotInclude(context)
                  .padding(vertical: Sizes.s15, horizontal: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextWidgetCommon(
                        text: appFonts.selectOption,
                        style: AppCss.lexendMedium18)
                    .padding(horizontal: Sizes.s20, vertical: Sizes.s15),
                //select option layout
                const SelectOptionLayout(),
                if (outCtrl.selectedOptionIndex != null)
                  outCtrl.data['title'] == appFonts.sharedRide ||
                          outCtrl.data['title'] == appFonts.parcel ||
                          outCtrl.data['title'] == appFonts.freight
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              DottedLine(
                                      dashColor:
                                          appColor(context).appTheme.stroke)
                                  .padding(horizontal: Sizes.s20),
                              OutStationWidgets()
                                  .commonLabelDesign(context)
                                  .padding(horizontal: Sizes.s20)
                            ])
                      : const SizedBox.shrink()
              ]).backgroundColor(appColor(context).appTheme.bgBox),
              //outstation all text and changes text layout
              const OutStationTextLayout(),
              CommonButton(
                      text: appFonts.bookRide,
                      onTap: () => route.pushNamed(
                          context, routeName.findingDriverScreen))
                  .padding(horizontal: Sizes.s20, vertical: Sizes.s30)
            ]))
          ])));
    });
  }
}
