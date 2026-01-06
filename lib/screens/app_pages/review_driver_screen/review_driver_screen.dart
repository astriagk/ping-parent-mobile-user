import 'package:taxify_user_ui/screens/app_pages/review_driver_screen/layouts/tip_layout.dart';
import '../../../config.dart';

class ReviewDriverScreen extends StatelessWidget {
  const ReviewDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CompletedRideProvider>(builder: (context, rideCtrl, child) {
      return Scaffold(
          appBar: CommonAppBarLayout(
              titleStyle: AppCss.lexendMedium18,
              padding: 0.0,
              title: appFonts.homeWasYourRide,
              radius: Sizes.s20,
              child: Text("Skip",
                      style: AppCss.lexendMedium14.textColor(Color(0xff797D83)))
                  .inkWell(
                      onTap: () => route.pushReplacementNamed(
                          context, routeName.dashBoardLayout))),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      Stack(children: [
                        Image.asset(imageAssets.driverBg, fit: BoxFit.fill),
                        Image.asset(imageAssets.profileImg,
                                width: Sizes.s100,
                                height: Sizes.s100,
                                fit: BoxFit.cover)
                            .center()
                            .padding(top: Sizes.s28)
                      ]),
                      DriverDetailsWidgets()
                          .commonTitleLayout(title: "Jonathan Higgins")
                          .center(),
                      VSpace(Insets.i4),
                      Text("jonathanhiggins001@gmail.com",
                              style: AppCss.lexendRegular12
                                  .textColor(Color(0xff797D83)))
                          .center(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgetCommon(
                                    style: AppCss.lexendMedium14,
                                    text: "Rate Us",
                                    fontSize: Sizes.s14,
                                    fontWeight: FontWeight.w500)
                                .padding(top: Sizes.s20, bottom: Sizes.s8),
                            IntrinsicHeight(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                  RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      unratedColor: appTheme.stroke,
                                      itemSize: 40,
                                      itemPadding:
                                          EdgeInsets.only(right: Insets.i12),
                                      itemBuilder: (context, _) =>
                                          SvgPicture.asset(svgAssets.star1),
                                      onRatingUpdate: (rating) {
                                        rideCtrl.setRatingValue(rating);
                                      }),
                                  VerticalDivider(
                                          color:
                                              appColor(context).appTheme.stroke,
                                          width: 0)
                                      .padding(
                                          vertical: Sizes.s4, horizontal: 10),
                                  TextWidgetCommon(
                                      style: AppCss.lexendMedium16,
                                      text: "${rideCtrl.ratingValue ?? 3}/5")
                                ]).padding(all: Sizes.s12).decorated(
                                    color: appColor(context).appTheme.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: appColor(context)
                                              .appTheme
                                              .primary
                                              .withValues(alpha: 0.03),
                                          blurRadius: 12,
                                          spreadRadius: 4)
                                    ],
                                    allRadius: Sizes.s10,
                                    sideColor:
                                        appColor(context).appTheme.bgBox)),
                            Divider(
                                    height: 0,
                                    color: appColor(context).appTheme.stroke)
                                .paddingDirectional(vertical: Sizes.s15),
                            TipSelectionScreen(),
                            TextWidgetCommon(
                                    style: AppCss.lexendMedium14,
                                    text: "Add comments",
                                    fontSize: Sizes.s14,
                                    fontWeight: FontWeight.w500)
                                .padding(top: Sizes.s20, bottom: Sizes.s8),
                            Container(
                                margin: EdgeInsets.only(bottom: 20),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey
                                              .withValues(alpha: 0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4))
                                    ]),
                                child: TextField(
                                    controller: rideCtrl.commentController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        hintStyle: AppCss.lexendLight14
                                            .textColor(appTheme.hintText),
                                        hintText: "Write your comment here...",
                                        border: InputBorder.none)))
                          ]).paddingSymmetric(horizontal: Insets.i20),
                      if (rideCtrl.selectedTip != null)
                        Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidgetCommon(
                                    style: AppCss.lexendMedium14,
                                    text: "Payment Method",
                                    fontSize: Sizes.s14,
                                    fontWeight: FontWeight.w500),
                                TextWidgetCommon(
                                    style: AppCss.lexendMedium12.textDecoration(
                                        TextDecoration.underline),
                                    text: "Changes",
                                    fontSize: Sizes.s14,
                                    fontWeight: FontWeight.w500),
                              ]),
                          SizedBox(height: Insets.i10),
                          Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4))
                                  ]),
                              child: Row(children: [
                                SvgPicture.asset(
                                  "assets/svg/home/gpay.svg",
                                  height: 24,
                                ),
                                const SizedBox(width: 8),
                                // Email and description
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('miketorello@okamerican',
                                              style: AppCss.lexendRegular14),
                                          SizedBox(height: 4),
                                          Text('Pay now to avoid cash payment',
                                              style: AppCss.lexendLight12
                                                  .textColor(Color(0xff797D83)))
                                        ])),
                                // Pay Now Button
                                Expanded(
                                    child: CommonButton(
                                        onTap: () => route.pushReplacementNamed(
                                            context, routeName.dashBoardLayout),
                                        style: AppCss.lexendMedium12
                                            .textColor(appTheme.white),
                                        text: "Pay Now"))
                              ]))
                        ]).padding(bottom: 20, horizontal: 20)
                    ]).authExtension(context))),
                CommonButton(
                    style: AppCss.lexendMedium15.textColor(appTheme.white),
                    text: "Submit Review",
                    onTap: () => route.pushReplacementNamed(
                        context, routeName.dashBoardLayout),
                    margin: EdgeInsets.symmetric(
                        horizontal: Insets.i20, vertical: Insets.i20))
              ]));
    });
  }
}
