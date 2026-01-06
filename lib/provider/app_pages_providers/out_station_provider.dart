import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:taxify_user_ui/config.dart';

class OutStationProvider extends ChangeNotifier {
  List selectOption = [];
  bool isPayment = false;
  dynamic passenger, data;
  int? selectedOptionIndex;

  //select card number dropDown layout
  List passengerDropDownItems = [
    {'value': 1, 'label': '1'},
    {'value': 2, 'label': '2'},
    {'value': 3, 'label': '3'},
    {'value': 4, 'label': '4'},
    {'value': 5, 'label': '5'},
    {'value': 6, 'label': '6'},
    {'value': 7, 'label': '7'},
    {'value': 8, 'label': '8'},
    {'value': 9, 'label': '9'},
    {'value': 10, 'label': '10'}
  ];

//list initialization
  onInit() {
    selectOption = appArray.selectOption;

    log("data :: $data ");
    notifyListeners();
  }

  //select payment method
  selectPayment() {
    isPayment = !isPayment;
    notifyListeners();
  }

  //state change value
  passengerValueChange(newValue) {
    passenger = newValue;
    notifyListeners();
  }

  //set select option index
  setSelectedOptionIndex(int index) {
    selectedOptionIndex = index;
    data = selectOption[selectedOptionIndex!];
    notifyListeners();
  }

  dateTime(context) {
    showModalBottomSheet(
        useRootNavigator: false,
        isScrollControlled: true,
        context: context,
        builder: (_) =>
            Consumer<DateTimeProvider>(builder: (context, dateTimePvr, child) {
              return StatefulBuilder(builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      Text("Select date and time",
                          style: AppCss.lexendLight14.textColor(
                              appColor(context).appTheme.hintTextClr)),
                      TextWidgetCommon(
                              text:
                                  "${DateFormat('dd MMM yyyy').format(dateTimePvr.focusedDay.value)}, ${appArray.hourList[dateTimePvr.scrollHourIndex]}:${appArray.minList[dateTimePvr.scrollMinIndex]} ${dateTimePvr.scrollDayIndex == 0 ? "AM" : "PM"}",
                              style: AppCss.lexendExtraBold18.textColor(
                                  appColor(context).appTheme.primary))
                          .padding(vertical: Sizes.s20),
                      ArrowDropDownLayout(setState, hSpace: 0),
                      const TableCalenderLayout(hSpace: 0)
                          .padding(top: Sizes.s15, bottom: Sizes.s20),
                      DateTimeWidgets().timePickerLayout(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: CommonButton(
                                    bgColor: appColor(context).appTheme.stroke,
                                    text: "Book ride",
                                    style: AppCss.lexendRegular15
                                        .textColor(Color(0xff797D83)),
                                    color: appColor(context).appTheme.lightText,
                                    onTap: () => route.pop(context))),
                            HSpace(Sizes.s15),
                            Expanded(
                                child: CommonButton(
                                    text: "Apply",
                                    onTap: () => route.pop(context)))
                          ]).padding(top: Sizes.s30, bottom: Sizes.s20)
                    ]).paddingDirectional(
                        horizontal: Insets.i20, top: Insets.i25));
              });
            }));
  }
}
