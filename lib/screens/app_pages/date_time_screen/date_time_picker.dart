import '../../../config.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime dateTime = DateTime.now();
  ScrollController hourController = ScrollController();
  ScrollController minuteController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DateTimeProvider>(builder: (context1, dateTimePvr, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => dateTimePvr.onInit(isEdit: false)),
          child: StatefulBuilder(builder: (context, setState) {
            return Scaffold(
                body: Column(children: [
              //Appbar back button and title layout
              DateTimeWidgets().appBarTitleRow(context),
              SingleChildScrollView(
                  child: Column(children: [
                //What time would you want ...picked up text layout
                DateTimeWidgets().whatTimePickedText(context),
                //Show date and time text layout
                DateTimeWidgets().dateTimeText(),
                //Right arrow - left arrow and month - year dropdown layout
                ArrowDropDownLayout(setState),
                const TableCalenderLayout()
                    .padding(top: Sizes.s15, bottom: Sizes.s20),
                //Time picker row layout
                DateTimeWidgets().timePickerLayout(),
                CommonButton(
                        text: appFonts.done,
                        onTap: () => dateTimePvr.doneButtonOnTap(context))
                    .padding(horizontal: Sizes.s20, vertical: Sizes.s25)
              ])).height(MediaQuery.of(context).size.height / 1.2).decorated(
                  tLRadius: Sizes.s10,
                  tRRadius: Sizes.s10,
                  color: appColor(context).appTheme.white)
            ]));
          }));
    });
  }
}
