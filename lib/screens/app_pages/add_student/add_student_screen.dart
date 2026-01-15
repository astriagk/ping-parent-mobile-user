import '../../../config.dart';
import '../../../widgets/common_app_bar_layout1.dart';
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

    // Print all form data
    print('=== FORM DATA ===');
    print('Student Name: ${studentCtrl.studentNameController.text}');
    print('Selected School ID (school_id): ${studentCtrl.selectedSchoolId}');
    print('Selected Class: ${studentCtrl.selectedClass}');
    print('Section: ${studentCtrl.sectionController.text}');
    print('Roll Number: ${studentCtrl.rollNumberController.text}');
    print('Selected Gender: ${studentCtrl.selectedGender}');
    print('Date of Birth: ${studentCtrl.dateOfBirthController.text}');
    print(
        'Selected Pickup Address ID (_id): ${studentCtrl.selectedPickupAddressId}');
    print('Emergency Contact: ${studentCtrl.emergencyContactController.text}');
    print('Medical Info: ${studentCtrl.medicalInfoController.text}');
    print('Photo URL: ${studentCtrl.photoUrlController.text}');
    print('================');

    final success = await studentCtrl.createStudent();

    if (mounted) {
      setState(() => _isSaving = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidgetCommon(
              text: studentCtrl.isEditMode
                  ? 'Student updated successfully'
                  : 'Student created successfully',
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

                // School (Required - Dropdown)
                widgets.commonDropdown(
                  context,
                  title: appFonts.schoolName,
                  hintText: appFonts.enterSchoolName,
                  value: studentCtrl.selectedSchoolId,
                  itemsList: studentCtrl.schoolList
                      .map((school) => DropdownMenuItem<dynamic>(
                            value: school.schoolId,
                            child: TextWidgetCommon(
                              text: school.schoolName,
                              fontSize: Sizes.s14,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    studentCtrl.selectedSchoolId = value;
                    studentCtrl.notifyListeners();
                  },
                ),

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
                    studentCtrl.selectedClass = value;
                    studentCtrl.notifyListeners();
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
                    studentCtrl.selectedGender = value;
                    studentCtrl.notifyListeners();
                  },
                ),

                // Date of Birth (Optional)
                widgets.commonTextField(
                  context,
                  title: appFonts.dateOfBirth,
                  hintText: appFonts.enterDateOfBirth,
                  controller: studentCtrl.dateOfBirthController,
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
                    studentCtrl.selectedPickupAddressId = value;
                    studentCtrl.notifyListeners();
                  },
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
