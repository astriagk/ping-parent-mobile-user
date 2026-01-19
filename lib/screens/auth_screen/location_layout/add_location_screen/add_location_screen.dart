import 'package:taxify_user_ui/config.dart';

class AddLocationScreen extends StatelessWidget {
  const AddLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddLocationProvider>(
        builder: (context, locationCtrl, child) {
      return StatefulWrapper(
          onInit: () =>
              Future.delayed(const Duration(milliseconds: 50)).then((value) {
                locationCtrl.getCurrentLocation();
              }),
          child: Scaffold(
              body: Stack(children: [
            if (locationCtrl.position != null)
              SizedBox(
                  child: Stack(children: [
                AddLocationWidgets().mapLayout(),
                CommonIconButton(
                        icon: svgAssets.back,
                        bgColor: appColor(context).appTheme.white,
                        onTap: () => route.pop(context))
                    .padding(left: Insets.i20, top: Insets.i50),
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //current position Icon layout
                  LocationWidgets().currentPositionIcon(context),
                  const SelectServiceLayout(),
                  //street,country,state,city,zip add location layout
                  const StreetAddressLayout()
                ])
              ]))
          ])));
    });
  }
}
