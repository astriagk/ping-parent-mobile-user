import '../../../config.dart';
import '../../../helper/distance_helper.dart';
import '../../../widgets/common_app_bar_layout1.dart';
import '../../../widgets/searchable_dropdown.dart';
import '../../../widgets/location/route_location_display.dart';
import '../../../widgets/location/route_distance_display.dart';
import '../../../api/models/school_response.dart';
import 'student_widgets.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final studentProvider = context.read<AddStudentProvider>();
      // Pre-select pickup address if available
      if (studentProvider.parentAddress != null &&
          studentProvider.selectedPickupAddressId == null) {
        studentProvider.selectedPickupAddressId =
            studentProvider.parentAddress!.id;
      }
    });
  }

  Future<void> _saveStudent() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    final studentCtrl = context.read<AddStudentProvider>();

    final success = await studentCtrl.createStudent();

    if (mounted) {
      setState(() => _isSaving = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidgetCommon(
              text: studentCtrl.isEditMode
                  ? appFonts.studentUpdatedSuccessfully
                  : appFonts.studentCreatedSuccessfully,
            ),
          ),
        );
        route.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidgetCommon(
              text: studentCtrl.errorMessage ?? 'Failed to save student',
            ),
          ),
        );
      }
    }
  }

  Widget _buildLocationPreview(
      BuildContext context, AddStudentProvider studentCtrl) {
    // Get selected school
    final selectedSchool = studentCtrl.schoolList.firstWhere(
      (school) => school.schoolId == studentCtrl.selectedSchoolId,
      orElse: () => studentCtrl.schoolList.first,
    );

    // Get pickup address
    final pickupAddress = studentCtrl.parentAddress;

    if (pickupAddress == null) return const SizedBox.shrink();

    final distance = DistanceHelper.calculateDistanceInKm(
      pickupAddress.latitude,
      pickupAddress.longitude,
      selectedSchool.latitude,
      selectedSchool.longitude,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VSpace(Sizes.s8),
        RouteLocationDisplay(
          data: {
            'currentLocation':
                '${appFonts.pickupLocation}\n${pickupAddress.displayAddress}',
            'addLocation':
                '${selectedSchool.schoolName}\n${selectedSchool.fullAddress}',
          },
          loc1Color: appColor(context).appTheme.darkText,
        ).padding(horizontal: Sizes.s10, vertical: Sizes.s10).decorated(
            color: appColor(context).appTheme.bgBox, allRadius: Sizes.s8),
        VSpace(Sizes.s8),
        RouteDistanceDisplay(
          distance: DistanceHelper.formatDistance(distance),
          distanceColor: DistanceHelper.getDistanceColor(
            distance,
            appColor(context).appTheme.primary,
            appColor(context).appTheme.success,
            appColor(context).appTheme.yellowIcon,
            appColor(context).appTheme.alertZone,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final widgets = StudentWidgets();

    return Consumer<AddStudentProvider>(builder: (context, studentCtrl, child) {
      return GestureDetector(
        onTap: () {
          // Unfocus any text field when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
                // Error message
                if (studentCtrl.errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(Sizes.s12),
                    margin: EdgeInsets.only(bottom: Sizes.s20),
                    decoration: BoxDecoration(
                      color: appColor(context)
                          .appTheme
                          .alertZone
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Sizes.s8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: appColor(context).appTheme.alertZone),
                        HSpace(Sizes.s10),
                        Expanded(
                          child: TextWidgetCommon(
                              text: studentCtrl.errorMessage!,
                              color: appColor(context).appTheme.alertZone),
                        ),
                      ],
                    ),
                  ),

                // ========== REQUIRED FIELDS ==========

                // Student Photo Upload
                widgets.studentPhotoLayout(
                  context,
                  photoUrl: studentCtrl.photoUrlController.text.isNotEmpty
                      ? studentCtrl.photoUrlController.text
                      : null,
                  onTap: () {
                    widgets.showPhotoSelectionDialog(
                      context,
                      onGalleryTap: () {
                        studentCtrl.selectPhotoFromGallery();
                      },
                      onCameraTap: () {
                        studentCtrl.selectPhotoFromCamera();
                      },
                    );
                  },
                ),

                // Student Name (Required)
                widgets.commonTextField(
                  context,
                  title: appFonts.studentName,
                  hintText: appFonts.enterStudentName,
                  controller: studentCtrl.studentNameController,
                ),

                // Pickup Address (Required - Dropdown)
                widgets.commonDropdown(
                  context,
                  title: appFonts.pickupAddress,
                  hintText: appFonts.enterPickupAddress,
                  value: studentCtrl.selectedPickupAddressId,
                  itemsList: studentCtrl.parentAddress != null
                      ? [
                          DropdownMenuItem<dynamic>(
                            value: studentCtrl.parentAddress!.id,
                            child: TextWidgetCommon(
                              text: studentCtrl.parentAddress!.displayAddress,
                              fontSize: Sizes.s14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ]
                      : [],
                  onChanged: (value) {
                    setState(() {
                      studentCtrl.selectedPickupAddressId = value;
                    });
                  },
                ),

                // School (Required - Searchable Dropdown)
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextWidgetCommon(
                    text: appFonts.schoolName,
                    style: AppCss.lexendMedium14
                        .textColor(appColor(context).appTheme.darkText),
                  ),
                  VSpace(Sizes.s8),
                  SearchableDropdown<School>(
                    items: studentCtrl.schoolList,
                    selectedItem: studentCtrl.schoolList.isNotEmpty &&
                            studentCtrl.selectedSchoolId != null
                        ? studentCtrl.schoolList.firstWhere(
                            (school) =>
                                school.schoolId == studentCtrl.selectedSchoolId,
                            orElse: () => studentCtrl.schoolList.first,
                          )
                        : null,
                    hintText: appFonts.enterSchoolName,
                    itemAsString: (school) => school.schoolName,
                    itemBuilder: (context, school, isSelected, isHighlighted) {
                      // Calculate distance if pickup address is selected
                      String? distanceText;
                      double? distanceInKm;
                      if (studentCtrl.selectedPickupAddressId != null &&
                          studentCtrl.parentAddress != null) {
                        distanceInKm = DistanceHelper.calculateDistanceInKm(
                          studentCtrl.parentAddress!.latitude,
                          studentCtrl.parentAddress!.longitude,
                          school.latitude,
                          school.longitude,
                        );
                        distanceText =
                            DistanceHelper.formatDistance(distanceInKm);
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s15, vertical: Sizes.s12),
                        decoration: BoxDecoration(
                          color: isHighlighted
                              ? appColor(context)
                                  .appTheme
                                  .primary
                                  .withValues(alpha: 0.1)
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextWidgetCommon(
                                    text: school.schoolName,
                                    fontSize: Sizes.s14,
                                    fontWeight: FontWeight.w500,
                                    color: appColor(context).appTheme.darkText,
                                  ),
                                ),
                                if (distanceText != null &&
                                    distanceInKm != null) ...[
                                  HSpace(Sizes.s8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Sizes.s8,
                                        vertical: Sizes.s4),
                                    decoration: BoxDecoration(
                                      color: DistanceHelper
                                          .getDistanceColorWithAlpha(
                                              distanceInKm,
                                              appColor(context)
                                                  .appTheme
                                                  .primary,
                                              appColor(context)
                                                  .appTheme
                                                  .success,
                                              appColor(context)
                                                  .appTheme
                                                  .yellowIcon,
                                              appColor(context)
                                                  .appTheme
                                                  .alertZone,
                                              0.1),
                                      borderRadius:
                                          BorderRadius.circular(Sizes.s4),
                                    ),
                                    child: TextWidgetCommon(
                                      text: distanceText,
                                      fontSize: Sizes.s11,
                                      fontWeight: FontWeight.w500,
                                      color: DistanceHelper.getDistanceColor(
                                          distanceInKm,
                                          appColor(context).appTheme.primary,
                                          appColor(context).appTheme.success,
                                          appColor(context).appTheme.yellowIcon,
                                          appColor(context).appTheme.alertZone),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (school.fullAddress.isNotEmpty) ...[
                              VSpace(Sizes.s2),
                              TextWidgetCommon(
                                text: school.fullAddress,
                                fontSize: Sizes.s12,
                                color: appColor(context).appTheme.lightText,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                    filterFn: (school, filter) {
                      return school.schoolName
                              .toLowerCase()
                              .contains(filter.toLowerCase()) ||
                          school.fullAddress
                              .toLowerCase()
                              .contains(filter.toLowerCase());
                    },
                    onChanged: (school) {
                      setState(() {
                        studentCtrl.selectedSchoolId = school?.schoolId;
                      });
                    },
                  ),
                  VSpace(Sizes.s16),
                ]),

                // Location Preview - shows when both school and pickup address are selected
                if (studentCtrl.selectedSchoolId != null &&
                    studentCtrl.selectedPickupAddressId != null)
                  _buildLocationPreview(context, studentCtrl),

                VSpace(Sizes.s16),

                // ========== OPTIONAL FIELDS ==========

                // Class (Optional - Dropdown)
                widgets.commonDropdown(
                  context,
                  title: appFonts.studentClass,
                  hintText: appFonts.selectClass,
                  value: studentCtrl.selectedClass,
                  itemsList: studentCtrl.classOptions
                      .map((classValue) => DropdownMenuItem<dynamic>(
                            value: classValue,
                            child: TextWidgetCommon(
                              text: classValue,
                              fontSize: Sizes.s14,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      studentCtrl.selectedClass = value;
                    });
                  },
                ),

                // Section (Optional)
                widgets.commonTextField(
                  context,
                  title: appFonts.section,
                  hintText: appFonts.enterSection,
                  controller: studentCtrl.sectionController,
                ),

                // Roll Number (Optional)
                widgets.commonTextField(
                  context,
                  title: appFonts.rollNumber,
                  hintText: appFonts.enterRollNumber,
                  controller: studentCtrl.rollNumberController,
                ),

                // Gender (Optional - Dropdown)
                widgets.commonDropdown(
                  context,
                  title: appFonts.gender,
                  hintText: appFonts.selectGender,
                  value: studentCtrl.selectedGender,
                  itemsList: studentCtrl.genderOptions
                      .map((gender) => DropdownMenuItem<dynamic>(
                            value: gender,
                            child: TextWidgetCommon(
                              text:
                                  gender[0].toUpperCase() + gender.substring(1),
                              fontSize: Sizes.s14,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      studentCtrl.selectedGender = value;
                    });
                  },
                ),

                // Date of Birth (Optional)
                widgets.commonTextField(
                  context,
                  title: appFonts.dateOfBirth,
                  hintText: appFonts.enterDateOfBirth,
                  controller: studentCtrl.dateOfBirthController,
                ),

                // Emergency Contact (Optional)
                widgets.commonTextField(
                  context,
                  title: appFonts.emergencyContact,
                  hintText: appFonts.enterEmergencyContact,
                  controller: studentCtrl.emergencyContactController,
                  textInputType: TextInputType.phone,
                ),

                // Medical Info (Optional)
                widgets.commonTextField(
                  context,
                  title: appFonts.medicalInfo,
                  hintText: appFonts.enterMedicalInfo,
                  controller: studentCtrl.medicalInfoController,
                  minLines: 3,
                  maxLines: 5,
                ),
              ]).padding(horizontal: Sizes.s20, vertical: Sizes.s20)),
          bottomNavigationBar: Padding(
              padding: EdgeInsets.all(Sizes.s20),
              child: CommonButton(
                  text: _isSaving
                      ? (studentCtrl.isEditMode
                          ? 'Updating Student...'
                          : 'Saving Student...')
                      : (studentCtrl.isEditMode
                          ? appFonts.updateStudent
                          : appFonts.saveStudent),
                  onTap: _isSaving ? null : _saveStudent)),
        ),
      );
    });
  }
}
