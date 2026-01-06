import '../../../../config.dart';

class TipSelectionScreen extends StatefulWidget {
  const TipSelectionScreen({super.key});

  @override
  State<TipSelectionScreen> createState() => _TipSelectionScreenState();
}

class _TipSelectionScreenState extends State<TipSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompletedRideProvider>(builder: (context, rideCtrl, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextWidgetCommon(
                style: AppCss.lexendMedium14,
                text: "Do you want to give a tip your driver?",
                fontSize: Sizes.s14,
                fontWeight: FontWeight.w500)
            .padding(bottom: Sizes.s8),
        SizedBox(
            height: Insets.i40,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: rideCtrl.tipOptions.length,
                itemBuilder: (context, index) {
                  return buildTipOption(rideCtrl.tipOptions[index], index);
                }))
      ]);
    });
  }

  Widget buildTipOption(String tipLabel, int index) {
    return Consumer<CompletedRideProvider>(builder: (context, rideCtrl, child) {
      return GestureDetector(
          onTap: () {
            setState(() {
              rideCtrl.selectedTip = index;
            });
          },
          child: Container(
              width: Insets.i70,
              height: Insets.i36,
              margin: EdgeInsets.only(right: Insets.i8),
              decoration: BoxDecoration(
                  color: rideCtrl.selectedTip == index
                      ? appTheme.primary
                      : appTheme.white,
                  borderRadius: BorderRadius.circular(Insets.i8)),
              alignment: Alignment.center,
              child: Text(tipLabel,
                  style: AppCss.lexendMedium13.textColor(
                      rideCtrl.selectedTip == index
                          ? appTheme.white
                          : appTheme.hintText))));
    });
  }
}
