import '../../../../config.dart';

class CardLayout extends StatelessWidget {
  const CardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return     Consumer<HomeScreenProvider>(
      builder: (context, homeCtrl, child) {
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: homeCtrl.cards
                    .asMap()
                    .entries
                    .map((e) => Row(children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(Sizes.s50))),
                      child: Image.asset(e.value, fit: BoxFit.fill,
                          width: Sizes.s270)),
                  if (e.key == 0) HSpace(Sizes.s15)
                ]))
                    .toList())).paddingSymmetric(vertical: Sizes.s25);
      }
    );
  }
}
