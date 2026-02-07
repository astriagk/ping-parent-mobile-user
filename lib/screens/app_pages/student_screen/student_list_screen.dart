import '../../../config.dart';
import '../../../widgets/common_app_bar_layout1.dart';
import '../../../widgets/common_empty_state.dart';
import '../../../widgets/common_error_state.dart';
import '../../../widgets/location/route_location_display.dart';
import '../../../widgets/location/route_distance_display.dart';
import '../../../widgets/ride_card/layout/ride_header_section.dart';
import '../../../widgets/ride_card/layout/ride_driver_info_section.dart';
import '../../../widgets/ride_card/layout/action_button_section.dart';
import '../../../widgets/ride_card/layout/ride_data_model.dart';
import '../../../widgets/status_badge.dart';
import '../../../helper/distance_helper.dart';
import '../../../helper/date_formatter_helper.dart';
import '../../../helper/status_helper.dart';
import '../../../widgets/skeletons/student_card_skeleton.dart';
import '../../../api/models/student_response.dart';
import '../driver_screen/assign_driver_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentCtrl =
          Provider.of<AddStudentProvider>(context, listen: false);
      studentCtrl.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddStudentProvider>(builder: (context, studentCtrl, child) {
      return Scaffold(
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
                          buttonText: language(context, appFonts.addStudent),
                          onButtonTap: () {
                            studentCtrl.clearForm();
                            route.pushNamed(
                                context, routeName.addStudentScreen);
                          })
                      : ListView(
                          padding: EdgeInsets.only(
                              top: Sizes.s20, bottom: Sizes.s20),
                          children: [
                              ...studentCtrl.studentList
                                  .asMap()
                                  .entries
                                  .map((entries) {
                                Student student = entries.value;
                                int index = entries.key;
                                return _buildStudentCard(
                                    context, studentCtrl, student, index);
                              })
                            ]));
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
          RideHeaderSection(
            rideData: RideDataModel(
              image: student.photoUrl ?? '',
              id: student.studentName ?? '',
              status: student.isActive ? 'Active' : 'Inactive',
              statusColor: student.isActive
                  ? appColor(context).appTheme.activeColor
                  : appColor(context).appTheme.alertZone,
              price:
                  'Class ${student.studentClass ?? ''}${student.section != null && student.section!.isNotEmpty ? ' - ${student.section}' : ''}',
              date: DateFormatterHelper.formatToShortDate(student.createdAt),
              time: DateFormatterHelper.formatTo12HourTime(student.createdAt),
            ),
          ),
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
              student.school!.latitude != null) ...[
            RouteLocationDisplay(
              data: {
                'currentLocation': student.pickupAddress!.fullAddress,
                'addLocation': student.school!.fullAddress,
              },
              loc1Color: appColor(context).appTheme.darkText,
            ).padding(horizontal: Sizes.s10, vertical: Sizes.s10).decorated(
                color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8),
            VSpace(Sizes.s8),
            RouteDistanceDisplay(
              distance: DistanceHelper.formatDistance(
                DistanceHelper.calculateDistanceInKm(
                  student.pickupAddress!.latitude!,
                  student.pickupAddress!.longitude!,
                  student.school!.latitude!,
                  student.school!.longitude!,
                ),
              ),
              distanceColor: DistanceHelper.getDistanceColor(
                DistanceHelper.calculateDistanceInKm(
                  student.pickupAddress!.latitude!,
                  student.pickupAddress!.longitude!,
                  student.school!.latitude!,
                  student.school!.longitude!,
                ),
                appColor(context).appTheme.primary,
                appColor(context).appTheme.success,
                appColor(context).appTheme.yellowIcon,
                appColor(context).appTheme.alertZone,
              ),
            ),
          ],
        ]).myRideListExtension(context));
  }

  Widget _buildAssignDriverButton(BuildContext context, Student student) {
    return ActionButtonSection(
      label: language(context, appFonts.assignDriver),
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
    ).paddingOnly(bottom: Sizes.s15);
  }

  Widget _buildDriverAssignmentCard(BuildContext context, Student student) {
    final driver = student.driver!;
    final assignment = student.driverAssignment!;
    final statusColor = StatusHelper.getAssignmentStatusColor(
        context, assignment.assignmentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Driver details row
        RideDriverInfoSection(
          rideData: RideDataModel(
            driverName: driver.name ?? 'Driver',
            rating: driver.rating != null
                ? driver.rating!.toStringAsFixed(1)
                : '0.0',
            userRatingNumber:
                driver.totalTrips != null ? ' (${driver.totalTrips})' : '',
            carName:
                '${driver.vehicleType.toDisplayString()} ${driver.vehicleNumber ?? ''}'
                    .trim(),
          ),
          profileImageUrl: driver.photoUrl,
        ),
        VSpace(Sizes.s6),
        // Status badge below vehicle number
        StatusBadge(
          status: assignment.statusDisplay,
          statusColor: statusColor,
        ),
      ],
    ).paddingOnly(bottom: Sizes.s15);
  }
}
