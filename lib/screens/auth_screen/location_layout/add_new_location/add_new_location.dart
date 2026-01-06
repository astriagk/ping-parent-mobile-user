import '../../../../config.dart';

class AddNewLocationScreen extends StatelessWidget {
  const AddNewLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddLocationProvider, NewLocationProvider>(
        builder: (context, locationCtrl, newCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => newCtrl.init()),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(Sizes.s53),
                        //title and back button layout
                        LocationWidgets().selectAppBarLayout(context),
                        // home,work, other radio category layout
                        const CategoryLayout()
                      ]),
                  // street,country,state,city,zip title and text-field layout
                  const TextFieldLayout()
                ]),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: CommonButton(
                        onTap: () =>
                            route.pushNamed(context, routeName.dashBoardLayout),
                        margin: EdgeInsets.all(Sizes.s20),
                        text: appFonts.addLocation))
              ])));
    });
  }
}
