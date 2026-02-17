import 'package:taxify_user_ui/config.dart';

class AddNewLocationScreen extends StatefulWidget {
  const AddNewLocationScreen({super.key});

  @override
  State<AddNewLocationScreen> createState() => _AddNewLocationScreenState();
}

class _AddNewLocationScreenState extends State<AddNewLocationScreen> {
  Future<void> _saveLocation() async {
    final locationCtrl = context.read<AddLocationProvider>();
    final success = await locationCtrl.saveAddress();

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidgetCommon(text: 'Address saved successfully'),
          ),
        );
        route.pushReplacementNamed(context, routeName.dashBoardLayout);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidgetCommon(
              text: locationCtrl.errorMessage ?? 'Failed to save address',
            ),
          ),
        );
      }
    }
  }

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
                // Error message display
                if (locationCtrl.errorMessage != null)
                  Positioned(
                    top: Sizes.s120,
                    left: Sizes.s20,
                    right: Sizes.s20,
                    child: Container(
                      padding: EdgeInsets.all(Sizes.s12),
                      decoration: BoxDecoration(
                        color: appColor(context)
                            .appTheme
                            .alertZone
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Sizes.s8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: appColor(context).appTheme.alertZone),
                          HSpace(Sizes.s10),
                          Expanded(
                            child: TextWidgetCommon(
                                text: locationCtrl.errorMessage!,
                                color: appColor(context).appTheme.alertZone),
                          ),
                        ],
                      ),
                    ),
                  ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: CommonButton(
                        onTap: _saveLocation,
                        isLoading: locationCtrl.isSaving,
                        margin: EdgeInsets.all(Sizes.s20),
                        text: appFonts.addLocation))
              ])));
    });
  }
}
