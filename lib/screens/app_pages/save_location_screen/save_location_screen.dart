import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/screens/app_pages/save_location_screen/save_location_widgets.dart';

class SaveLocationScreen extends StatelessWidget {
  const SaveLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SaveLocationProvider>(builder: (context, slCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => slCtrl.init()),
          child: Scaffold(
              appBar: CommonAppBarLayout(
                  onTap: () =>
                      route.pushNamed(context, routeName.addNewLocationScreen),
                  title: appFonts.savedLocation,
                  icon: true,
                  suffixIcon: svgAssets.add),
              body: slCtrl.saveLocationList.isNotEmpty
                  ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: slCtrl.saveLocationList.map((e) {
                            return Column(children: [
                              //ICON WORK OR HOME EDIT AND DELETE LAYOUT
                              WorkTitleLayout(e: e),
                              //save location page save address layout
                              SaveLocationWidgets()
                                  .saveAddressLayout(e, context)
                            ])
                                .decorated(
                                    color: appColor(context).appTheme.bgBox,
                                    allRadius: Sizes.s10)
                                .padding(bottom: Sizes.s20);
                          }).toList())
                      .padding(horizontal: Sizes.s20, top: Sizes.s25)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Center(
                              child: Container(
                                  child: Text("No Address",
                                      style: AppCss.lexendLight16
                                          .textColor(appTheme.hintText))))
                        ])));
    });
  }
}
