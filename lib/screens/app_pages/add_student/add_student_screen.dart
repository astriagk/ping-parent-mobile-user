import '../../../config.dart';
import '../../../widgets/common_app_bar_layout1.dart';

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddStudentProvider>(builder: (context, studentCtrl, child) {
      return Scaffold(
          backgroundColor: appColor(context).appTheme.white,
          appBar: CommonAppBarLayout1(
              title: language(
                  context,
                  studentCtrl.isEditMode
                      ? appFonts.updateStudent
                      : appFonts.addStudent),
              titleWidth: MediaQuery.of(context).size.width * 0.01),
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                TextWidgetCommon(
                        text: appFonts.studentName, fontWeight: FontWeight.w500)
                    .padding(bottom: Sizes.s8),
                TextFieldCommon(
                    hintText: appFonts.enterStudentName,
                    color: appColor(context).appTheme.bgBox),
                TextWidgetCommon(
                        text: appFonts.schoolName, fontWeight: FontWeight.w500)
                    .padding(top: Sizes.s20, bottom: Sizes.s8),
                TextFieldCommon(
                    hintText: appFonts.enterSchoolName,
                    color: appColor(context).appTheme.bgBox),
                TextWidgetCommon(text: appFonts.grade, fontWeight: FontWeight.w500)
                    .padding(top: Sizes.s20, bottom: Sizes.s8),
                TextFieldCommon(
                    hintText: appFonts.enterGrade,
                    color: appColor(context).appTheme.bgBox),
                Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        TextWidgetCommon(
                                text: appFonts.pickupTime,
                                fontWeight: FontWeight.w500)
                            .padding(top: Sizes.s20, bottom: Sizes.s8),
                        TextFieldCommon(
                            hintText: appFonts.enterPickupTime,
                            color: appColor(context).appTheme.bgBox)
                      ])),
                  HSpace(Sizes.s15),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        TextWidgetCommon(
                                text: appFonts.dropTime,
                                fontWeight: FontWeight.w500)
                            .padding(top: Sizes.s20, bottom: Sizes.s8),
                        TextFieldCommon(
                            hintText: appFonts.enterDropTime,
                            color: appColor(context).appTheme.bgBox)
                      ]))
                ]),
                TextWidgetCommon(
                        text: appFonts.pickupAddress,
                        fontWeight: FontWeight.w500)
                    .padding(top: Sizes.s20, bottom: Sizes.s8),
                TextFieldCommon(
                    hintText: appFonts.enterPickupAddress,
                    color: appColor(context).appTheme.bgBox),
                TextWidgetCommon(
                        text: appFonts.dropAddress, fontWeight: FontWeight.w500)
                    .padding(top: Sizes.s20, bottom: Sizes.s8),
                TextFieldCommon(
                    hintText: appFonts.enterDropAddress,
                    color: appColor(context).appTheme.bgBox),
              ]).padding(horizontal: Sizes.s20, vertical: Sizes.s20)),
          bottomNavigationBar: Padding(
              padding: EdgeInsets.all(Sizes.s20),
              child: CommonButton(
                      text: studentCtrl.isEditMode
                          ? appFonts.updateStudent
                          : appFonts.saveStudent)
                  .inkWell(onTap: () => route.pop(context))));
    });
  }
}
