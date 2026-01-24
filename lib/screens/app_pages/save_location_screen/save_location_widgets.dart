import 'package:taxify_user_ui/config.dart';

import '../../../widgets/common_location_layout.dart';

class SaveLocationWidgets {
  //save location page save address layout
  Widget saveAddressLayout(e, BuildContext context) {
    return Column(children: [
      CommonLocationLayout(
          index: 6,
          pickUpAddress: e['address'],
          droppingAddress: e['droppingAddress']),
    ]);
  }
}
