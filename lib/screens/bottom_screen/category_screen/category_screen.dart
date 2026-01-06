import '../../../config.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, catCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => catCtrl.onInit()),
          child: Scaffold(
              body: Column(
                      children: catCtrl.categoryList
                          .asMap()
                          .entries
                          .map((e) => IntrinsicHeight(
                                  child: Row(children: [
                                Expanded(
                                    flex: 1,
                                    child: Image.asset(e.value['image'],
                                        fit: BoxFit.fill)),
                                VerticalDivider(
                                        width: 0,
                                        color:
                                            appColor(context).appTheme.stroke)
                                    .padding(horizontal: Sizes.s15),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      TextWidgetCommon(
                                          text: e.value['title'],
                                          fontWeight: FontWeight.w500),
                                      VSpace(Sizes.s5),
                                      TextWidgetCommon(
                                          text: e.value['subtitle'],
                                          fontSize: Sizes.s11,
                                          color: appColor(context)
                                              .appTheme
                                              .lightText),
                                      VSpace(Sizes.s20),
                                      SvgPicture.asset(svgAssets.rightCategory)
                                    ]))
                              ])
                                      .padding(all: Sizes.s15)
                                      .decorated(
                                          color:
                                              appColor(context).appTheme.bgBox,
                                          allRadius: Sizes.s6)
                                      .inkWell(onTap: () {
                                if (e.key == 0) {
                                  route.pushNamed(
                                      context, routeName.searchLocationScreen);
                                }
                                if (e.key == 1) {
                                  route.pushNamed(
                                      context, routeName.outStationScreen);
                                }
                                if (e.key == 2) {
                                  route.pushNamed(
                                      context, routeName.rentalScreen);
                                }
                              })).padding(bottom: Sizes.s15))
                          .toList())
                  .padding(horizontal: Sizes.s20, vertical: Sizes.s25)));
    });
  }
}
