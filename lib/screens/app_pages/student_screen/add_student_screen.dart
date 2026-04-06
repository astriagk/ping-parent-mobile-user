import 'package:skolo/api/models/school_response.dart';
import 'package:skolo/config.dart';
import 'package:skolo/helper/distance_helper.dart';
import 'package:skolo/widgets/common_app_bar_layout1.dart';
import 'package:skolo/widgets/location/route_distance_display.dart';
import 'package:skolo/widgets/location/route_location_display.dart';
import 'package:skolo/widgets/searchable_dropdown.dart';

import 'student_widgets.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
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

  Future<void> _selectDate(
      BuildContext context, AddStudentProvider studentCtrl) async {
    final now = DateTime.now();
    final initial = studentCtrl.dateOfBirthController.text.isNotEmpty
        ? _parseDate(studentCtrl.dateOfBirthController.text) ?? now
        : now;
    final darkText = appColor(context).appTheme.darkText;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              onSurface: darkText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      studentCtrl.dateOfBirthController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  DateTime? _parseDate(String value) {
    try {
      final parts = value.split('-');
      if (parts.length == 3) {
        return DateTime(
            int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      }
    } catch (_) {}
    return null;
  }

  Future<void> _saveStudent() async {
    final studentCtrl = context.read<AddStudentProvider>();
    final wasEditMode = studentCtrl.isEditMode;

    final success = await studentCtrl.createStudent();

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: appColor(context).appTheme.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.s8)),
            content: Row(children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.white, size: 20),
              HSpace(Sizes.s8),
              Expanded(
                child: TextWidgetCommon(
                  text: wasEditMode
                      ? appFonts.studentUpdatedSuccessfully
                      : appFonts.studentCreatedSuccessfully,
                  color: Colors.white,
                ),
              ),
            ]),
          ),
        );
        route.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: appColor(context).appTheme.alertZone,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.s8)),
            content: Row(children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              HSpace(Sizes.s8),
              Expanded(
                child: TextWidgetCommon(
                  text: studentCtrl.errorMessage ?? 'Failed to save student',
                  color: Colors.white,
                ),
              ),
            ]),
          ),
        );
      }
    }
  }

  Widget _buildLocationPreview(
      BuildContext context, AddStudentProvider studentCtrl) {
    // Get selected school
    final selectedSchool = studentCtrl.schoolList.firstWhere(
      (school) => school.id == studentCtrl.selectedSchoolId,
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
                // ========== REQUIRED FIELDS ==========

                // Student Photo Upload
                widgets.studentPhotoLayout(
                  context,
                  photoUrl: studentCtrl.photoUrlController.text.isNotEmpty
                      ? studentCtrl.photoUrlController.text
                      : null,
                  selectedPhotoFile: studentCtrl.selectedPhotoFile,
                  onTap: () {
                    widgets.showPhotoSelectionDialog(
                      context,
                      onGalleryTap: studentCtrl.selectPhotoFromGallery,
                      onCameraTap: studentCtrl.selectPhotoFromCamera,
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
                        ? studentCtrl.schoolList.cast<School?>().firstWhere(
                            (school) =>
                                school?.id == studentCtrl.selectedSchoolId,
                            orElse: () => null,
                          )
                        : null,
                    hintText: appFonts.enterSchoolName,
                    searchHintText: 'Search by name or city...',
                    popupHeight: 400,
                    itemAsString: (school) => school.schoolName,
                    // Show school icon + name + full address in the button when selected
                    dropdownBuilder: (context, school) {
                      if (school == null) return const SizedBox.shrink();
                      return Row(
                        children: [
                          Icon(Icons.school_rounded,
                              size: Sizes.s18,
                              color: appColor(context).appTheme.primary),
                          HSpace(Sizes.s8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidgetCommon(
                                  text: school.schoolName,
                                  fontSize: Sizes.s13,
                                  fontWeight: FontWeight.w600,
                                  color: appColor(context).appTheme.darkText,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (school.address.isNotEmpty)
                                  TextWidgetCommon(
                                    text: school.address,
                                    fontSize: Sizes.s11,
                                    color:
                                        appColor(context).appTheme.lightText,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (school.city.isNotEmpty ||
                                    school.state.isNotEmpty)
                                  TextWidgetCommon(
                                    text: [school.city, school.state]
                                        .where((s) => s.isNotEmpty)
                                        .join(', '),
                                    fontSize: Sizes.s11,
                                    color:
                                        appColor(context).appTheme.lightText,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    // Popup item rows
                    itemBuilder: (context, school, isSelected, isHighlighted) {
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

                      final distanceColor = distanceInKm != null
                          ? DistanceHelper.getDistanceColor(
                              distanceInKm,
                              appColor(context).appTheme.primary,
                              appColor(context).appTheme.success,
                              appColor(context).appTheme.yellowIcon,
                              appColor(context).appTheme.alertZone)
                          : null;

                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s15, vertical: Sizes.s10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? appColor(context)
                                  .appTheme
                                  .primary
                                  .withValues(alpha: 0.08)
                              : isHighlighted
                                  ? appColor(context).appTheme.screenBg
                                  : null,
                          border: isSelected
                              ? Border(
                                  left: BorderSide(
                                      color:
                                          appColor(context).appTheme.primary,
                                      width: 3))
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: Sizes.s36,
                              height: Sizes.s36,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? appColor(context)
                                        .appTheme
                                        .primary
                                        .withValues(alpha: 0.15)
                                    : appColor(context)
                                        .appTheme
                                        .primary
                                        .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(Sizes.s8),
                              ),
                              child: Icon(
                                Icons.school_rounded,
                                size: Sizes.s18,
                                color: isSelected
                                    ? appColor(context).appTheme.primary
                                    : appColor(context)
                                        .appTheme
                                        .primary
                                        .withValues(alpha: 0.6),
                              ),
                            ),
                            HSpace(Sizes.s12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextWidgetCommon(
                                          text: school.schoolName,
                                          fontSize: Sizes.s13,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: appColor(context)
                                              .appTheme
                                              .darkText,
                                        ),
                                      ),
                                      if (distanceText != null &&
                                          distanceColor != null) ...[
                                        HSpace(Sizes.s6),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Sizes.s6,
                                              vertical: Sizes.s2),
                                          decoration: BoxDecoration(
                                            color: distanceColor
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(Sizes.s4),
                                          ),
                                          child: TextWidgetCommon(
                                            text: distanceText,
                                            fontSize: Sizes.s10,
                                            fontWeight: FontWeight.w600,
                                            color: distanceColor,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (school.address.isNotEmpty ||
                                      school.city.isNotEmpty ||
                                      school.state.isNotEmpty) ...[
                                    VSpace(Sizes.s2),
                                    if (school.address.isNotEmpty)
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              size: Sizes.s11,
                                              color: appColor(context)
                                                  .appTheme
                                                  .lightText),
                                          HSpace(Sizes.s2),
                                          Expanded(
                                            child: TextWidgetCommon(
                                              text: school.address,
                                              fontSize: Sizes.s11,
                                              color: appColor(context)
                                                  .appTheme
                                                  .lightText,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (school.city.isNotEmpty ||
                                        school.state.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: Sizes.s11 + Sizes.s2),
                                        child: TextWidgetCommon(
                                          text: [school.city, school.state]
                                              .where((s) => s.isNotEmpty)
                                              .join(', '),
                                          fontSize: Sizes.s11,
                                          color: appColor(context)
                                              .appTheme
                                              .lightText,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle_rounded,
                                  size: Sizes.s18,
                                  color: appColor(context).appTheme.primary),
                          ],
                        ),
                      );
                    },
                    // No-results empty state
                    emptyBuilder: (context, filter) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: Sizes.s40,
                              color: appColor(context)
                                  .appTheme
                                  .lightText
                                  .withValues(alpha: 0.5)),
                          VSpace(Sizes.s8),
                          TextWidgetCommon(
                            text: 'No school found for "$filter"',
                            fontSize: Sizes.s13,
                            color: appColor(context).appTheme.lightText,
                          ),
                        ],
                      ).padding(vertical: Sizes.s24),
                    ),
                    filterFn: (school, filter) {
                      final q = filter.toLowerCase();
                      return school.schoolName.toLowerCase().contains(q) ||
                          school.city.toLowerCase().contains(q) ||
                          school.state.toLowerCase().contains(q) ||
                          school.address.toLowerCase().contains(q);
                    },
                    onChanged: (school) {
                      if (school != null) {
                        studentCtrl.selectSchool(school.id);
                      }
                    },
                  ),
                  VSpace(Sizes.s16),
                ]),

                // Location Preview - shows when both school and pickup address are selected
                if (studentCtrl.selectedSchoolId != null &&
                    studentCtrl.selectedPickupAddressId != null) ...[
                  _buildLocationPreview(context, studentCtrl),
                  VSpace(Sizes.s16),
                ],

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
                GestureDetector(
                  onTap: () => _selectDate(context, studentCtrl),
                  child: AbsorbPointer(
                    child: widgets.commonTextField(
                      context,
                      title: appFonts.dateOfBirth,
                      hintText: appFonts.enterDateOfBirth,
                      controller: studentCtrl.dateOfBirthController,
                      readOnly: true,
                    ),
                  ),
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
                  text: studentCtrl.isEditMode
                      ? appFonts.updateStudent
                      : appFonts.saveStudent,
                  isLoading: studentCtrl.isSaving,
                  onTap: _saveStudent)),
        ),
      );
    });
  }
}
