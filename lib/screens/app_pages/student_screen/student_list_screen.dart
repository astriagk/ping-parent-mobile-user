import '../../../config.dart';
import '../../../widgets/common_app_bar_layout1.dart';
import '../../../widgets/common_empty_state.dart';
import '../../../widgets/common_error_state.dart';
import '../../../widgets/location_preview_card.dart';
import '../../../models/location_data.dart';
import '../../../widgets/skeletons/student_card_skeleton.dart';
import '../../../api/models/student_response.dart';
import '../driver_screen/assign_driver_screen.dart';

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
          // Student info row with photo
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
                                fontSize: Sizes.s13,
                                fontWeight: FontWeight.w400,
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
                  Row(children: [
                    TextWidgetCommon(
                        text: 'Class ${student.studentClass ?? ''}',
                        color: appColor(context).appTheme.lightText,
                        fontSize: Sizes.s12,
                        fontWeight: FontWeight.w300),
                    if (student.section != null &&
                        student.section!.isNotEmpty) ...[
                      TextWidgetCommon(
                          text: ' - ${student.section}',
                          color: appColor(context).appTheme.lightText,
                          fontSize: Sizes.s12,
                          fontWeight: FontWeight.w300),
                    ]
                  ])
                ]))
          ]),
          DottedLine(dashColor: appColor(context).appTheme.stroke)
              .padding(vertical: Sizes.s15),

          // Driver assignment card or assign driver button
          if (student.driverAssignment != null && student.driver != null)
            _buildDriverAssignmentCard(context, student)
          else
            _buildAssignDriverButton(context, student),

          // Location preview card
          if (student.pickupAddress != null &&
              student.school != null &&
              student.pickupAddress!.latitude != null &&
              student.school!.latitude != null)
            LocationPreviewCard(
              showBottomSpace: false,
              locations: [
                LocationData(
                  name: appFonts.pickupLocation,
                  address: student.pickupAddress!.fullAddress,
                  latitude: student.pickupAddress!.latitude!,
                  longitude: student.pickupAddress!.longitude!,
                ),
                LocationData(
                  name: student.school!.schoolName ?? '',
                  address: student.school!.fullAddress,
                  latitude: student.school!.latitude!,
                  longitude: student.school!.longitude!,
                ),
              ],
            ),
        ]).myRideListExtension(context));
  }

  Widget _buildAssignDriverButton(BuildContext context, Student student) {
    return GestureDetector(
      onTap: () {
        if (student.studentId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssignDriverScreen(
                studentId: student.studentId!,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TextWidgetCommon(text: appFonts.driverIdNotAvailable),
            ),
          );
        }
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: Sizes.s12, vertical: Sizes.s10),
        decoration: BoxDecoration(
          color: appColor(context).appTheme.bgBox,
          borderRadius: BorderRadius.circular(Sizes.s8),
          border: Border.all(
            color: appColor(context).appTheme.stroke,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_add_outlined,
                  size: Sizes.s20,
                  color: appColor(context).appTheme.primary,
                ),
                HSpace(Sizes.s10),
                TextWidgetCommon(
                  text: language(context, appFonts.assignDriver),
                  fontSize: Sizes.s13,
                  fontWeight: FontWeight.w500,
                  color: appColor(context).appTheme.darkText,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: Sizes.s14,
              color: appColor(context).appTheme.lightText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverAssignmentCard(BuildContext context, Student student) {
    final driver = student.driver!;
    final assignment = student.driverAssignment!;

    Color statusColor;
    switch (assignment.assignmentStatus) {
      case 'active':
        statusColor = appColor(context).appTheme.success;
        break;
      case 'parent_requested':
      case 'pending':
        statusColor = appColor(context).appTheme.yellowIcon;
        break;
      case 'rejected':
      case 'inactive':
        statusColor = appColor(context).appTheme.alertZone;
        break;
      default:
        statusColor = appColor(context).appTheme.lightText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Driver details row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextWidgetCommon(
                          text: driver.name ?? 'Driver',
                          fontSize: Sizes.s12,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (driver.rating != null && driver.rating! > 0) ...[
                        HSpace(Sizes.s6),
                        SvgPicture.asset(svgAssets.star),
                        HSpace(Sizes.s4),
                        TextWidgetCommon(
                          text: driver.rating!.toStringAsFixed(1),
                          fontSize: Sizes.s12,
                          fontWeight: FontWeight.w400,
                        ),
                        TextWidgetCommon(
                          text: ' (${driver.totalTrips ?? 0})',
                          color: appColor(context).appTheme.lightText,
                          fontSize: Sizes.s12,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ],
                  ),
                  VSpace(Sizes.s4),
                  TextWidgetCommon(
                    text:
                        '${driver.vehicleType?.toUpperCase() ?? ''} ${driver.vehicleNumber ?? ''}'
                            .trim(),
                    color: appColor(context).appTheme.lightText,
                    fontSize: Sizes.s12,
                  ),
                  VSpace(Sizes.s6),
                  // Status badge below vehicle number
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Sizes.s8, vertical: Sizes.s4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Sizes.s4),
                    ),
                    child: TextWidgetCommon(
                      text: "• ${assignment.statusDisplay}",
                      fontSize: Sizes.s12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Insets.i32,
              width: Insets.i32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.s7),
                color: appColor(context).appTheme.bgBox,
                image: driver.photoUrl != null && driver.photoUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(driver.photoUrl!),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      )
                    : null,
              ),
              child: driver.photoUrl == null || driver.photoUrl!.isEmpty
                  ? Icon(Icons.person,
                      size: Sizes.s20,
                      color: appColor(context).appTheme.lightText)
                  : null,
            ),
          ],
        ),
      ],
    ).paddingOnly(bottom: Sizes.s15);
  }
}
