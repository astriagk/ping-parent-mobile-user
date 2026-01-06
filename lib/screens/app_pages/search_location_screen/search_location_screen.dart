import 'package:taxify_user_ui/config.dart';

class SearchLocationScreen extends StatelessWidget {
  const SearchLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchLocationProvider>(
        builder: (context, searchCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => searchCtrl.onInit()),
          child: Scaffold(
              body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Column(children: [
              VSpace(Sizes.s30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CommonIconButton(
                    icon: svgAssets.back, onTap: () => route.pop(context)),
                //common switch rider layout
                const CommonSwitchRider()
              ]),
              VSpace(Sizes.s20),
              IntrinsicHeight(
                  child: Row(children: [
                //add icon with TextField layout
                SearchLocationWidgets().addIconLayout(),
                HSpace(Sizes.s10),
                //add new TextField layout
                SearchLocationWidgets().addTextFieldLayout()
              ]).padding(horizontal: Sizes.s15).decorated(
                      allRadius: Sizes.s10,
                      color: appColor(context).appTheme.white))
            ])
                .padding(horizontal: Sizes.s20, vertical: Sizes.s20)
                .authExtension(context),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  //addHome and addWork Layout
                  SearchLocationWidgets().homeWorkRowLayout(),
                  //recent history layout
                  const RecentLayout(),
                ]).padding(horizontal: Sizes.s20))),
            CommonButton(
                text: appFonts.done,
                onTap: () {
                  route.pushNamed(context, routeName.selectRiderScreen);
                }).padding(horizontal: Sizes.s20, bottom: Insets.i15)
          ])));
    });
  }
}
