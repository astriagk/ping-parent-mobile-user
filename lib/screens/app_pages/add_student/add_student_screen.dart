import '../../../config.dart';
import '../../../widgets/common_app_bar_layout1.dart';
import 'student_widgets.dart';

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

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
                  itemsList: studentCtrl.dummySchools
                      .map((school) => DropdownMenuItem<dynamic>(
                            value: school['id'],
                            child: TextWidgetCommon(
                              text: school['name']!,
                              fontSize: Sizes.s14,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    studentCtrl.selectedSchoolId = value;
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
                              text: gender,
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
                  itemsList: studentCtrl.dummyPickupAddresses
                      .map((address) => DropdownMenuItem<dynamic>(
                            value: address['id'],
                            child: TextWidgetCommon(
                              text: address['address']!,
                              fontSize: Sizes.s14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
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
              child: studentCtrl.isSaving
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CommonButton(
                          text: studentCtrl.isEditMode
                              ? appFonts.updateStudent
                              : appFonts.saveStudent)
                      .inkWell(onTap: () async {
                      final success = await studentCtrl.createStudent();
                      if (success && context.mounted) {
                        route.pop(context);
                      }
                    })),
        ),
      );
    });
  }
}
