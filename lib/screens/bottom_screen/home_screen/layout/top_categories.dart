import 'package:taxify_user_ui/screens/open_free_maps/ofm_examples_menu.dart';

import '../../../../config.dart';
import '../../../maps/maps_examples_menu.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, homeCtrl, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextWidgetCommon(
            text: appFonts.topCategories,
            style: AppCss.lexendMedium18
                .textColor(appColor(context).appTheme.darkText)),
        Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: homeCtrl.categories
                    .asMap()
                    .entries
                    .map((e) => Container(
                            height: Sizes.s104,
                            width: Sizes.s100,
                            decoration: BoxDecoration(
                                color: appColor(context).appTheme.bgBox,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Sizes.s12))),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(e.value['image']).padding(
                                      horizontal: Sizes.s12,
                                      bottom:
                                          e.key == 0 ? Sizes.s16 : Sizes.s14),
                                  TextWidgetCommon(
                                      text: e.value['title'],
                                      style: AppCss.lexendMedium12.textColor(
                                          appColor(context).appTheme.darkText)),
                                  VSpace(Sizes.s13)
                                ])).inkWell(onTap: () {
                          if (e.key == 0) {
                            route.pushNamed(
                                context, routeName.studentListScreen);
                          }
                          if (e.key == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MapsExamplesMenu()),
                            );
                          }
                          if (e.key == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OFMExamplesMenu()),
                            );
                          }
                        }))
                    .toList())
            .paddingOnly(top: Sizes.s15)
      ]);
    });
  }
}
