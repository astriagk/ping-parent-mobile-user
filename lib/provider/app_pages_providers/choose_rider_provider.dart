import '../../config.dart';

class ChooseRiderProvider extends ChangeNotifier {
  List<Contact>? contactsList;
  bool permissionDenied = false;

  onInit() {
    fetchContacts();
    notifyListeners();
  }

  Future fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      permissionDenied = true;
      notifyListeners();
    } else {
      final contacts = await FlutterContacts.getContacts();
      contactsList = contacts;
      notifyListeners();
    }
  }

  // Widget body() {
  //   return ListView.builder(
  //       itemCount: contactsList!.length,
  //       itemBuilder: (context, i) => Column(children: [
  //             Row(children: [
  //               Container(
  //                   height: Sizes.s38,
  //                   width: Sizes.s38,
  //                   decoration: BoxDecoration(
  //                       color: appColor(context).appTheme.bgBox,
  //                       shape: BoxShape.circle),
  //                   child: SvgPicture.asset(svgAssets.contactLight)),
  //               HSpace(Sizes.s16),
  //               TextWidgetCommon(text: contactsList![i].displayName)
  //             ]).padding(vertical: Sizes.s15),
  //             if (i != contactsList!.length - 1)
  //               Divider(color: appColor(context).appTheme.stroke, height: 0)
  //           ]).padding(horizontal: Sizes.s20));
  // }
}
