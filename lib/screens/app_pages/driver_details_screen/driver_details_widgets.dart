import '../../../config.dart';

class DriverDetailsWidgets {
//driver details screen profile image,profile background image layout
  Widget profileBgImage(context, data) => Stack(children: [
        Image.asset(imageAssets.driverBg,
            width: MediaQuery.of(context).size.width),
        Image.asset(data['image'],
                width: Sizes.s100, height: Sizes.s100, fit: BoxFit.cover)
            .center()
            .padding(top: Sizes.s28)
      ]).padding(top: Sizes.s25, bottom: Sizes.s10);

//total trip ,rating,total year layout
  Widget totalTripRatingYearLayout(context, e) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextWidgetCommon(text: e['totalData'], fontSize: Sizes.s20),
      TextWidgetCommon(
          text: e['dataTitle'],
          fontSize: Sizes.s12,
          color: appColor(context).appTheme.lightText)
    ]).padding(horizontal: Sizes.s20).height(Sizes.s95).commonBgBox(context);
  }

//car full name, code and car image layout
  Widget carFullNameCode(context, data) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidgetCommon(text: data['fullCarName']),
                  VSpace(Sizes.s20),
                  Row(children: [
                    TextWidgetCommon(
                        text: data['code'],
                        fontSize: Sizes.s18,
                        fontWeight: FontWeight.w600),
                    HSpace(Sizes.s6),
                    SvgPicture.asset(svgAssets.car)
                  ])
                ]),
            Transform.flip(
                flipX: true,
                child: Image.asset(imageAssets.luxuryInfo, height: Sizes.s44))
          ]).carDetailsExtension(context);

// common title layout
  Widget commonTitleLayout({String? title}) => TextWidgetCommon(
      text: title, fontSize: Sizes.s16, fontWeight: FontWeight.w500);

//user reviews layout
  Widget userReview(context, e) => Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Image.asset(e['reviewerProfile'],
                height: Sizes.s24, width: Sizes.s24, fit: BoxFit.cover),
            HSpace(Sizes.s7),
            TextWidgetCommon(text: e['name']),
            HSpace(Sizes.s32),
            SvgPicture.asset(svgAssets.star),
            HSpace(Sizes.s4),
            TextWidgetCommon(
                text: e['rating'],
                fontSize: Sizes.s12,
                color: appColor(context).appTheme.lightText)
          ]),
          VSpace(Sizes.s30),
          TextWidgetCommon(
              text: e['comments'],
              fontSize: Sizes.s12,
              color: appColor(context).appTheme.lightText)
        ]).reviewExtension(context),
        HSpace(Sizes.s12)
      ]);
}
