import '../../config.dart';

class SearchLocationProvider extends ChangeNotifier {
  List<String> textFieldList = [];
  bool isAdd = false;
  List workHomeList = [];
  List recentLocationList = [];

  //init list data
  onInit() {
    workHomeList = appArray.workHomeList;
    recentLocationList = appArray.recentLocationList;
    if (textFieldList.isEmpty) textFieldList.insert(0, "");
    notifyListeners();
  }

  //get TextField data
  getTextFieldData(context) {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < textFieldList.length; i++) {
      friendsTextFields.add(Column(children: [
        Divider(color: appColor(context).appTheme.stroke, height: 0),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: AddTextFormField(
                      index: i,
                      suffix: IntrinsicHeight(
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            VerticalDivider(
                                    color: appColor(context).appTheme.stroke,
                                    width: 0)
                                .padding(vertical: Sizes.s7),
                            HSpace(Sizes.s10),
                            addRemoveButton(i == textFieldList.length - 1, i,
                                textFieldList[i])
                          ]))))
            ])
      ]));
    }
    return friendsTextFields;
  }

  /// add / remove button
  Widget addRemoveButton(bool add, int index, String text) {
    return InkWell(
        onTap: () {
          if (add) {
            textFieldList.insert(0, "");
          } else {
            textFieldList.removeAt(index);
          }
          notifyListeners();
        },
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.black));
  }
}
