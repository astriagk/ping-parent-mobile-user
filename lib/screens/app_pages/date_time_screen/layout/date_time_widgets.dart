import 'package:intl/intl.dart';
import '../../../../config.dart';

class DateTimeWidgets {
  //time picker row layout
  Widget timePickerLayout() {
    return Consumer<DateTimeProvider>(builder: (context, dateTimePvr, child) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomTimePicker(
            title: language(context, appFonts.hour),
            itemList: appArray.hourList,
            carouselController: dateTimePvr.carouselController,
            onScroll: (index) => dateTimePvr.onHourScroll(index)),
        HSpace(Sizes.s10),
        SvgPicture.asset(svgAssets.colonIcon,
            colorFilter: ColorFilter.mode(Color(0xff797D83), BlendMode.srcIn)),
        HSpace(Sizes.s11),
        CustomTimePicker(
            title: appFonts.minute,
            itemList: appArray.minList,
            onScroll: (index) => dateTimePvr.onMinScroll(index),
            carouselController: dateTimePvr.carouselController1),
        HSpace(Sizes.s25),
        CustomTimePicker(
            title: appFonts.day,
            onScroll: (index) => dateTimePvr.onDayScroll(index),
            carouselController: dateTimePvr.carouselController2,
            itemList: appArray.amPmList)
      ]);
    });
  }

//appbar back button and title layout
  Widget appBarTitleRow(context) => Row(children: [
        HSpace(Sizes.s20),
        CommonIconButton(icon: svgAssets.back, onTap: () => route.pop(context))
            .backButtonBorderExtension(context),
        HSpace(Sizes.s50),
        TextWidgetCommon(
            text: appFonts.dateTimeSchedule,
            style: AppCss.lexendMedium18
                .textColor(appColor(context).appTheme.darkText))
      ]).padding(top: Sizes.s50, bottom: Sizes.s20);

//what time would you want ...picked up text layout
  Widget whatTimePickedText(context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: TextWidgetCommon(
                    text: appFonts.whatTimeWouldYou,
                    style: AppCss.lexendSemiBold14
                        .textColor(appTheme.primary)
                        .textHeight(1.2),
                    textAlign: TextAlign.center)
                .padding(vertical: Sizes.s15, horizontal: Sizes.s50))
      ]).backgroundColor(appColor(context).appTheme.stroke);

//show date and time text layout
  Widget dateTimeText() =>
      Consumer<DateTimeProvider>(builder: (context, dateTimePvr, child) {
        return TextWidgetCommon(
                text:
                    "${DateFormat('dd MMM yyyy').format(dateTimePvr.focusedDay.value)}, ${appArray.hourList[dateTimePvr.scrollHourIndex]}:${appArray.minList[dateTimePvr.scrollMinIndex]} ${dateTimePvr.scrollDayIndex == 0 ? "AM" : "PM"}",
                style: AppCss.lexendExtraBold18
                    .textColor(appColor(context).appTheme.yellowIcon))
            .padding(vertical: Sizes.s20)
            .center();
      });
}
