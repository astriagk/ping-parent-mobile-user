import 'package:taxify_user_ui/config.dart';

class ChooseRiderScreen extends StatelessWidget {
  const ChooseRiderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChooseRiderProvider>(builder: (context, chooseCtrl, child) {
      if (chooseCtrl.contactsList == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => chooseCtrl.onInit()),
          child: Scaffold(
              appBar: CommonAppBarLayout(
                  title: appFonts.chooseARider,
                  icon: true,
                  suffixIcon: svgAssets.userPlus,
                  onTap: () =>
                      route.pushNamed(context, routeName.addNewRiderScreen)),
              body: ListView.builder(
                  itemCount: chooseCtrl.contactsList!.length,
                  itemBuilder: (context, i) {
                    return Column(children: [
                      Row(children: [
                        Container(
                            height: Sizes.s38,
                            width: Sizes.s38,
                            decoration: BoxDecoration(
                                color: appColor(context).appTheme.bgBox,
                                shape: BoxShape.circle),
                            child: SvgPicture.asset(svgAssets.contactLight)),
                        HSpace(Sizes.s16),
                        Expanded(
                            child: TextWidgetCommon(
                                text: chooseCtrl.contactsList![i].displayName))
                      ]).padding(vertical: Sizes.s15).inkWell(
                          onTap: () => route.pushNamed(
                              context, routeName.selectRiderScreen)),
                      if (i != chooseCtrl.contactsList!.length - 1)
                        Divider(
                            color: appColor(context).appTheme.stroke, height: 0)
                    ]).padding(horizontal: Sizes.s20);
                  })));
    });
  }
}
