import 'package:taxify_user_ui/screens/app_pages/rental_info_screen/rental_info_widgets.dart';

import '../../../config.dart';

class RentalInfoScreen extends StatelessWidget {
  const RentalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RentalProvider>(builder: (context, rentalCtrl, child) {
      var data = rentalCtrl.vehicleType[rentalCtrl.selectedIndex!];
      List dataList = data['rentalInfo'];
      List policiesList = data['policiesList'];
      return Scaffold(
          appBar: const CommonAppBarLayout(title: "Your Rentals Ride"),
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Image.asset(data['infoImage']).padding(
                    horizontal: Sizes.s67, top: Sizes.s35, bottom: Sizes.s25),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidgetCommon(
                            text: data['rentalTitle'],
                            fontSize: Sizes.s16,
                            fontWeight: FontWeight.w600),
                        Row(children: [
                          SvgPicture.asset(svgAssets.profileDark,
                              height: Sizes.s14, width: Sizes.s14),
                          HSpace(Sizes.s2),
                          TextWidgetCommon(
                              text: data['person'], fontSize: Sizes.s14)
                        ])
                      ]),
                  Divider(color: appColor(context).appTheme.stroke, height: 0)
                      .padding(top: Sizes.s12, bottom: Sizes.s15),
                  ...dataList.asMap().entries.map((e) => RentalInfoWidgets()
                      .commonTextInfoLayout(context,
                          data: e,
                          title: e.value['time'],
                          subTitle: e.value['sub']))
                ])
                    .padding(
                        horizontal: Sizes.s20,
                        top: Sizes.s15,
                        bottom: Sizes.s25)
                    .backgroundColor(appColor(context).appTheme.bgBox),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextWidgetCommon(
                          text: data['policiesTitle'],
                          fontSize: Sizes.s16,
                          fontWeight: FontWeight.w600)
                      .padding(top: Sizes.s20, bottom: Sizes.s15),
                  ...policiesList.asMap().entries.map((e) => RentalInfoWidgets()
                      .commonTextInfoLayout(context,
                          data: e,
                          title: e.value['PTitle'],
                          subTitle: e.value['pSubTitle']))
                ]).padding(horizontal: Sizes.s20)
              ])));
    });
  }
}
