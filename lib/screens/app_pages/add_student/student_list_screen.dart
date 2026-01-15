import '../../../config.dart';
import '../../../widgets/common_app_bar_layout1.dart';
import '../../../widgets/common_empty_state.dart';
import '../../../widgets/common_error_state.dart';
import '../../../widgets/skeletons/student_card_skeleton.dart';
import '../../../api/models/student_response.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddStudentProvider>(builder: (context, studentCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => studentCtrl.onInit()),
          child: Scaffold(
              backgroundColor: appColor(context).appTheme.white,
              appBar: CommonAppBarLayout1(
                  title: language(context, appFonts.studentList),
                  titleWidth: MediaQuery.of(context).size.width * 0.01,
                  icon: true,
                  onTap: () {
                    studentCtrl.clearForm();
                    route.pushNamed(context, routeName.addStudentScreen);
                  }),
              body: studentCtrl.isLoading
                  ? const StudentListSkeleton()
                  : studentCtrl.errorMessage != null
                      ? CommonErrorState(
                          title: appFonts.somethingWentWrong,
                          description: studentCtrl.errorMessage!,
                          buttonText: appFonts.refresh,
                          onButtonTap: () => studentCtrl.fetchStudents())
                      : studentCtrl.studentList.isEmpty
                          ? CommonEmptyState(
                              mainText: appFonts.noStudentsAdded,
                              descriptionText: appFonts.addYourFirstStudent,
                              buttonText:
                                  language(context, appFonts.addStudent),
                              onButtonTap: () {
                                studentCtrl.clearForm();
                                route.pushNamed(
                                    context, routeName.addStudentScreen);
                              })
                          : ListView(
                              padding: EdgeInsets.only(
                                  top: Sizes.s20, bottom: Sizes.s20),
                              children: [
                                  ...studentCtrl.studentList!
                                      .asMap()
                                      .entries
                                      .map((entries) {
                                    Student student = entries.value;
                                    int index = entries.key;
                                    return _buildStudentCard(
                                        context, studentCtrl, student, index);
                                  })
                                ])));
    });
  }

  Widget _buildStudentCard(BuildContext context, AddStudentProvider studentCtrl,
      Student student, int index) {
    return GestureDetector(
        onTap: () {
          studentCtrl.setEditStudent(index);
          route.pushNamed(context, routeName.addStudentScreen);
        },
        child: Column(children: [
          Row(children: [
            Container(
                height: Sizes.s50,
                width: Sizes.s50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColor(context).appTheme.bgBox,
                    image:
                        student.photoUrl != null && student.photoUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(student.photoUrl!),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {})
                            : null),
                child: student.photoUrl == null || student.photoUrl!.isEmpty
                    ? Icon(Icons.person,
                        size: Sizes.s30,
                        color: appColor(context).appTheme.lightText)
                    : null),
            HSpace(Sizes.s10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextWidgetCommon(
                                text: student.studentName ?? '',
                                fontSize: Sizes.s14,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis)),
                        TextWidgetCommon(
                            text: student.isActive ? "• Active" : "• Inactive",
                            color: student.isActive
                                ? appColor(context).appTheme.activeColor
                                : appColor(context).appTheme.alertZone,
                            fontSize: Sizes.s12,
                            fontWeight: FontWeight.w500)
                      ]),
                  VSpace(Sizes.s4),
                  TextWidgetCommon(
                      text: student.school?.schoolName ?? '',
                      color: appColor(context).appTheme.lightText,
                      fontSize: Sizes.s12,
                      fontWeight: FontWeight.w400)
                ]))
          ]),
          DottedLine(dashColor: appColor(context).appTheme.stroke)
              .padding(vertical: Sizes.s12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                TextWidgetCommon(
                    text: 'ID: ${student.schoolId ?? ''}',
                    fontSize: Sizes.s12,
                    fontWeight: FontWeight.w400),
                HSpace(Sizes.s10),
                Container(
                    height: Sizes.s4,
                    width: Sizes.s4,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColor(context).appTheme.lightText)),
                HSpace(Sizes.s10),
                TextWidgetCommon(
                    text: student.studentClass ?? '',
                    fontSize: Sizes.s12,
                    fontWeight: FontWeight.w400),
                if (student.section != null && student.section!.isNotEmpty) ...[
                  HSpace(Sizes.s5),
                  TextWidgetCommon(
                      text: '- ${student.section}',
                      fontSize: Sizes.s12,
                      fontWeight: FontWeight.w400),
                ]
              ]),
            ]),
            CommonIconButton(
                icon: svgAssets.arrowRight,
                height: Sizes.s32,
                width: Sizes.s32,
                bgColor: appColor(context).appTheme.bgBox)
          ]),
          VSpace(Sizes.s12),
          Row(children: [
            SvgPicture.asset(svgAssets.locationSearch),
            HSpace(Sizes.s10),
            Expanded(
                child: TextWidgetCommon(
                    text: student.pickupAddress?.fullAddress ?? '',
                    color: appColor(context).appTheme.darkText,
                    fontSize: Sizes.s13,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400))
          ]).padding(horizontal: Sizes.s10, vertical: Sizes.s10).decorated(
              color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8),
        ]).myRideListExtension(context));
  }
}
