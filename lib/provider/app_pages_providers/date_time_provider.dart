import 'dart:developer';
import 'package:intl/intl.dart';

import '../../config.dart';

class DateTimeProvider with ChangeNotifier {
  int? selectIndex;
  bool isStep2 = false;
  SharedPreferences? pref;

  CalendarFormat calendarFormatMonth = CalendarFormat.month;
  bool visible = true;
  int val = 1;
  double loginWidth = 100.0;
  CarouselSliderController carouselController = CarouselSliderController();
  CarouselSliderController carouselController1 = CarouselSliderController();
  CarouselSliderController carouselController2 = CarouselSliderController();
  int amIndex = 0;
  int timeIndex = 0;
  bool? isWeek;

  int demoInt = 0;
  dynamic chosenValue;
  DateTime? selectedDay;
  DateTime selectedYear = DateTime.now();

  dynamic slotChosenValue;
  DateTime? slotSelectedDay;
  DateTime slotSelectedYear = DateTime.now();

  int selectedIndex = 0;
  int scrollDayIndex = 0;
  int scrollMinIndex = 0;
  int scrollHourIndex = 0;
  String showYear = 'Select Year';

  PageController pageController = PageController();
  CalendarFormat calendarFormat = CalendarFormat.week;
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());

  void onDaySelected(DateTime selectDay, DateTime fDay) {
    notifyListeners();
    focusedDay.value = selectDay;
  }

  onTapNext() {
    isStep2 = true;
    notifyListeners();
  }

  onChangeSlot(index) {
    timeIndex = index;
    notifyListeners();
  }

  onAmPmChange(index) {
    amIndex = index;
    notifyListeners();
  }

  onInit({isEdit = false}) async {
    if (isEdit) {
      focusedDay.value = DateTime.utc(focusedDay.value.year,
          focusedDay.value.month, focusedDay.value.day + 0);
      onDaySelected(focusedDay.value, focusedDay.value);
      DateTime dateTime = DateTime.now();
      int index = appArray.monthList
          .indexWhere((element) => element['index'] == dateTime.month);
      chosenValue = appArray.monthList[index];
      notifyListeners();
    } else {
      DateTime dateTime = DateTime.now();
      focusedDay.value =
          DateTime.utc(dateTime.year, dateTime.month, dateTime.day + 0);
      onDaySelected(focusedDay.value, focusedDay.value);

      int index = appArray.monthList
          .indexWhere((element) => element['index'] == dateTime.month);
      chosenValue = appArray.monthList[index];
      appArray.hourList.sort(
        (a, b) => a.compareTo(b),
      );
      scrollHourIndex = appArray.hourList.indexWhere((element) {
        log("element::${dateTime.hour}");
        return element == dateTime.hour.toString();
      });
      scrollMinIndex = appArray.minList
          .indexWhere((element) => element == dateTime.minute.toString());
      carouselController.jumpToPage(scrollHourIndex);
      carouselController1.jumpToPage(scrollMinIndex);
      amIndex = DateFormat("a").format(dateTime) == "AM" ? 0 : 1;
      carouselController2.jumpToPage(amIndex);
    }
    notifyListeners();
  }

  onMinDecrement() {
    if (scrollMinIndex > 0) {
      scrollMinIndex--;
    }
    carouselController1.jumpToPage(scrollMinIndex);
    notifyListeners();
  }

  onMinIncrement() {
    if (scrollMinIndex < appArray.minList.length - 1) {
      scrollMinIndex++;
    }
    notifyListeners();
    carouselController1.jumpToPage(scrollMinIndex);
    notifyListeners();
  }

  onDayDecrement() {
    if (scrollDayIndex > 0) {
      scrollDayIndex--;
    }
    notifyListeners();
    carouselController2.jumpToPage(scrollDayIndex);
    notifyListeners();
  }

  onDayIncrement() {
    if (scrollDayIndex < appArray.dayList.length) {
      scrollDayIndex++;
    }
    notifyListeners();
    carouselController2.jumpToPage(scrollDayIndex);
    notifyListeners();
  }

  onDropDownChange(choseVal) async {
    notifyListeners();
    int index = choseVal['index'];

    DateTime now =
        DateTime.utc(focusedDay.value.year, index, focusedDay.value.day);
    if (now.isAfter(DateTime.now()) ||
        DateFormat('MMMM-yyyy').format(now) ==
            DateFormat('MMMM-yyyy').format(focusedDay.value)) {
      chosenValue = choseVal;
      notifyListeners();
      focusedDay.value =
          DateTime.utc(focusedDay.value.year, index, focusedDay.value.day + 0);
    } else {
      if (DateFormat('MMMM-yyyy').format(now) ==
          DateFormat('MMMM-yyyy').format(DateTime.now())) {
        focusedDay.value = DateTime.utc(
            focusedDay.value.year, index, focusedDay.value.day + 0);
        onDaySelected(focusedDay.value, focusedDay.value);
      } else {
        notifyListeners();
        await Future.delayed(DurationClass.s3);
        notifyListeners();
      }
    }
  }

  onPageCtrl(dayFocused) {
    focusedDay.value = dayFocused;
    demoInt = dayFocused.year;
    log("dayFocused :: $demoInt");
    notifyListeners();
  }

  onHourScroll(index) {
    scrollHourIndex = index;
    notifyListeners();
  }

  onMinScroll(index) {
    scrollMinIndex = index;
    notifyListeners();
  }

  onDayScroll(index) {
    scrollDayIndex = index;
    notifyListeners();
  }

  onCalendarCreate(controller) {
    log("controller : $controller");
    pageController = controller;
  }

  selectYear(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context3) {
          return const YearAlertDialog();
        });
  }

  onLeftArrow() async {
    DateTime now = DateTime.now();
    if (DateFormat('MM-yyyy').format(focusedDay.value) !=
        DateFormat('MM-yyyy').format(now)) {
      pageController.previousPage(
          duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
      final newMonth = focusedDay.value.subtract(const Duration(days: 30));
      focusedDay.value = newMonth;
      int index = appArray.monthList
          .indexWhere((element) => element['index'] == focusedDay.value.month);
      chosenValue = appArray.monthList[index];
      selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
          focusedDay.value.day + 0);
      notifyListeners();
    } else {
      notifyListeners();
      await Future.delayed(DurationClass.s3);

      notifyListeners();
    }
    log("FFF : $focusedDay");
  }

  onRightArrow() {
    pageController.nextPage(
        duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
    final newMonth = focusedDay.value.add(const Duration(days: 30));
    focusedDay.value = newMonth;
    int index = appArray.monthList
        .indexWhere((element) => element['index'] == focusedDay.value.month);
    chosenValue = appArray.monthList[index];
    selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
        focusedDay.value.day + 0);
    notifyListeners();
    log("hbfbfdbf::::::$newMonth");
  }

  onDateTimeSelect(context, index) {
    selectIndex = index;
    notifyListeners();
  }

  checkSlotAvailableForAppChoose({context, isEdit = false}) async {
    focusedDay.value = DateTime.utc(
      focusedDay.value.year,
      focusedDay.value.month,
      focusedDay.value.day + 0,
      int.parse(appArray.hourList[scrollHourIndex]),
      int.parse(appArray.minList[scrollMinIndex]),
    );
    log("focusedDay.value :${focusedDay.value}");
    try {
      dateTimeSelect(context, isEdit: isEdit);
    } catch (e) {
      notifyListeners();
    }
  }

  doneButtonOnTap(context) {
    route.pop(context);
    checkSlotAvailableForAppChoose(context: context);
  }

  dateTimeSelect(context, {isEdit = false}) {
    focusedDay.value = DateTime.utc(
      focusedDay.value.year,
      focusedDay.value.month,
      focusedDay.value.day,
      int.parse(appArray.hourList[scrollHourIndex]),
      int.parse(appArray.minList[scrollMinIndex]),
    );
    notifyListeners();

    if (isEdit) {
      route.pop(context, arg: {
        "date": focusedDay.value,
        "time": appArray.amPmList[scrollDayIndex]
      });
    }
  }
}
