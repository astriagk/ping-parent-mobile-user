import 'package:taxify_user_ui/config.dart';
import 'package:taxify_user_ui/screens/app_pages/save_location_screen/save_location_widgets.dart';
import 'package:taxify_user_ui/widgets/skeletons/save_location_skeleton.dart';

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
                  //  TODO: hidden icon so user can't add multiple addresses quickly,
                  //  it will be coming in next phase.
                  icon: false,
                  suffixIcon: svgAssets.add),
              // Use ternary operators directly in body (per screen_loading_pattern.md)
              body: slCtrl.isLoading
                  // 1. Loading state - skeleton loader
                  ? const SaveLocationListSkeleton(itemCount: 1)
                  : slCtrl.errorMessage != null
                      // 2. Error state
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: Sizes.s48,
                                color: appColor(context).appTheme.alertZone,
                              ),
                              VSpace(Sizes.s16),
                              TextWidgetCommon(
                                text: slCtrl.errorMessage!,
                                style: AppCss.lexendLight14.textColor(
                                    appColor(context).appTheme.hintText),
                                textAlign: TextAlign.center,
                              ),
                              VSpace(Sizes.s20),
                              CommonButton(
                                text: appFonts.refresh,
                                onTap: () => slCtrl.refresh(),
                              ).padding(horizontal: Sizes.s40),
                            ],
                          ),
                        )
                      : slCtrl.saveLocationList.isEmpty
                          // 3. Empty state
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: TextWidgetCommon(
                                    text: "No Address",
                                    style: AppCss.lexendLight16
                                        .textColor(appTheme.hintText),
                                  ),
                                ),
                              ],
                            )
                          // 4. Data state - using existing UI layout
                          : Column(
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
                                            color: appColor(context)
                                                .appTheme
                                                .bgBox,
                                            allRadius: Sizes.s10)
                                        .padding(bottom: Sizes.s20);
                                  }).toList())
                              .padding(horizontal: Sizes.s20, top: Sizes.s25)));
    });
  }
}
