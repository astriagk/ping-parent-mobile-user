import 'package:intl/intl.dart';

import '../../../../config.dart';

class TableCalenderLayout extends StatelessWidget {
  final double? hSpace;
  const TableCalenderLayout({super.key, this.hSpace});

  @override
  Widget build(BuildContext context) {
    var dateTimePvr = Provider.of<DateTimeProvider>(context);
    return TableCalendar(
            rowHeight: 55,
            headerVisible: false,
            daysOfWeekVisible: true,
            pageJumpingEnabled: true,
            pageAnimationEnabled: false,
            lastDay: DateTime.utc(DateTime.now().year + 100, 3, 14),
            firstDay: DateTime.utc(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            onDaySelected: dateTimePvr.onDaySelected,
            focusedDay: dateTimePvr.focusedDay.value,
            availableGestures: AvailableGestures.none,
            calendarFormat: dateTimePvr.isWeek == true
                ? dateTimePvr.calendarFormat
                : dateTimePvr.calendarFormatMonth,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
                leftChevronVisible: false,
                formatButtonVisible: false,
                rightChevronVisible: false),
            onPageChanged: (dayFocused) => dateTimePvr.onPageCtrl(dayFocused),
            onCalendarCreated: (controller) =>
                dateTimePvr.onCalendarCreate(controller),
            selectedDayPredicate: (day) =>
                isSameDay(dateTimePvr.focusedDay.value, day),
            daysOfWeekStyle: DaysOfWeekStyle(
                dowTextFormatter: (date, locale) =>
                    DateFormat.E(locale).format(date)[0],
                weekdayStyle: AppCss.lexendBold14
                    .textColor(appColor(context).appTheme.primary),
                weekendStyle: AppCss.lexendBold14
                    .textColor(appColor(context).appTheme.primary)),
            calendarStyle: CalendarStyle(
                markerSizeScale: 10,
                selectedTextStyle:
                    AppCss.lexendLight14.textColor(appTheme.primary),
                selectedDecoration: BoxDecoration(
                    color: appTheme.yellowIcon, shape: BoxShape.circle),
                defaultTextStyle: AppCss.lexendLight14
                    .textColor(appColor(context).appTheme.darkText),
                todayTextStyle: AppCss.lexendMedium14
                    .textColor(appColor(context).appTheme.primary),
                todayDecoration: BoxDecoration(
                    color: appColor(context)
                        .appTheme
                        .primary
                        .withValues(alpha: .10),
                    shape: BoxShape.circle)))
        .paddingSymmetric(vertical: Insets.i10)
        .boxShapeExtension(
            color: appColor(context).appTheme.white,
            borderColor: appColor(context).appTheme.bgBox,
            context: context)
        .paddingSymmetric(horizontal: hSpace ?? Insets.i20);
  }
}
