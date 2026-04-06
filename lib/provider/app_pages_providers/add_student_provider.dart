import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:skolo/config.dart';
import '../../api/api_client.dart';
import '../../api/services/student_service.dart';
import '../../api/models/student_response.dart';
import '../../api/models/add_student_request.dart';
import '../../api/models/school_response.dart' as school_model;
import '../../api/models/parent_address_response.dart';

class AddStudentProvider extends ChangeNotifier {
  List<Student> studentList = [];
  List<school_model.School> schoolList = [];
  ParentAddress? parentAddress;
  bool isLoading = true; // Start with loading true to prevent empty state flash
  bool isSaving = false;
  String? errorMessage;
  bool _isInitialized = false;

  // Edit mode
  bool isEditMode = false;
  int? editIndex;
  Student? currentStudent;
  File? selectedPhotoFile;
  String? originalPhotoUrl;

  // Form controllers
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();
  final TextEditingController photoUrlController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();
  final TextEditingController medicalInfoController = TextEditingController();

  // Dropdown values
  String? selectedSchoolId;
  String? selectedPickupAddressId;
  String? selectedGender;
  String? selectedClass;

  final List<String> genderOptions = ['male', 'female', 'other'];
  final List<String> classOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  Future<void> onInit() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // Fetch all required data on first initialization
    await fetchSchools();
    await fetchParentAddress();
    await fetchStudents();
  }

  Future<void> refreshData() async {
    isLoading = true;
    notifyListeners(); // Notify immediately so UI shows loading state

    try {
      await fetchSchools();
      await fetchParentAddress();
      await fetchStudents();
    } catch (e) {
      print('Error refreshing data: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  // Reset provider data and initialization flag (for logout)
  void resetProvider() {
    _isInitialized = false;
    studentList = [];
    schoolList = [];
    parentAddress = null;
    isLoading = true;
    isSaving = false;
    errorMessage = null;
    isEditMode = false;
    editIndex = null;
    currentStudent = null;
    selectedSchoolId = null;
    selectedPickupAddressId = null;
    selectedGender = null;
    selectedClass = null;
    clearForm();
    notifyListeners();
  }

  Future<void> fetchSchools() async {
    try {
      final studentService = StudentService(ApiClient());
      final response = await studentService.getSchools();

      if (response.success) {
        schoolList = response.data;
        // Sort schools alphabetically by school name
        schoolList.sort((a, b) => a.schoolName.compareTo(b.schoolName));
      }
    } catch (e) {
      print('Error fetching schools: $e');
    }
    notifyListeners();
  }

  Future<void> fetchParentAddress() async {
    try {
      final studentService = StudentService(ApiClient());
      final response = await studentService.getParentAddress();

      if (response != null && response.success) {
        parentAddress = response.data;
      }
    } catch (e) {
      print('Error fetching parent address: $e');
    }
    notifyListeners();
  }

  Future<void> fetchStudents() async {
    errorMessage = null;
    notifyListeners();

    try {
      final studentService = StudentService(ApiClient());
      final response = await studentService.getMyStudents();

      if (response.success) {
        studentList = response.data;
        errorMessage = null;
      } else {
        errorMessage =
            response.error ?? response.message ?? 'Failed to fetch students';
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  // Clear form for adding new student
  clearForm() {
    isEditMode = false;
    editIndex = null;
    currentStudent = null;
    studentNameController.clear();
    sectionController.clear();
    rollNumberController.clear();
    photoUrlController.clear();
    dateOfBirthController.clear();
    emergencyContactController.clear();
    medicalInfoController.clear();
    selectedSchoolId = null;
    selectedPickupAddressId = null;
    selectedGender = null;
    selectedClass = null;
    selectedPhotoFile = null;
    originalPhotoUrl = null;
    notifyListeners();
  }

  // Set form for editing existing student
  setEditStudent(int index) {
    currentStudent = studentList[index];
    isEditMode = true;
    editIndex = index;

    // Populate form with current student data
    studentNameController.text = currentStudent?.studentName ?? '';
    // Only set selectedClass if it's a valid option (1-10)
    selectedClass = classOptions.contains(currentStudent?.studentClass)
        ? currentStudent?.studentClass
        : null;
    sectionController.text = currentStudent?.section ?? '';
    rollNumberController.text = currentStudent?.rollNumber ?? '';
    photoUrlController.text = currentStudent?.photoUrl ?? '';
    originalPhotoUrl = currentStudent?.photoUrl;
    selectedPhotoFile = null;
    dateOfBirthController.text = currentStudent?.dateOfBirth ?? '';
    emergencyContactController.text = currentStudent?.emergencyContact ?? '';
    medicalInfoController.text = currentStudent?.medicalInfo ?? '';
    selectedSchoolId = currentStudent?.schoolId;
    selectedPickupAddressId = currentStudent?.pickupAddressId;
    selectedGender = currentStudent?.gender;

    notifyListeners();
  }

  // Create student
  Future<bool> createStudent() async {
    // Validate required fields
    if (studentNameController.text.trim().isEmpty) {
      errorMessage = 'Please enter student name';
      notifyListeners();
      return false;
    }
    print('Selected School ID: $selectedSchoolId');
    if (selectedSchoolId == null || selectedSchoolId!.isEmpty) {
      errorMessage = 'Please select a school';
      notifyListeners();
      return false;
    }

    if (selectedPickupAddressId == null || selectedPickupAddressId!.isEmpty) {
      errorMessage = 'Please select a pickup address';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      String? photoUrlForPayload = photoUrlController.text.trim().isNotEmpty
          ? photoUrlController.text.trim()
          : null;

      if (selectedPhotoFile != null) {
        final studentService = StudentService(ApiClient());
        final uploadResult = await studentService.uploadSharedFile(
          file: selectedPhotoFile!,
          folderPath: 'student',
          oldFileUrl: isEditMode &&
                  originalPhotoUrl != null &&
                  originalPhotoUrl!.isNotEmpty
              ? originalPhotoUrl
              : null,
        );

        if (uploadResult['success'] != true) {
          errorMessage = uploadResult['message']?.toString() ??
              uploadResult['error']?.toString() ??
              'Failed to upload student photo';
          isSaving = false;
          notifyListeners();
          return false;
        }

        photoUrlForPayload = uploadResult['url']?.toString();
        if (photoUrlForPayload == null || photoUrlForPayload.isEmpty) {
          errorMessage = 'Failed to get uploaded photo URL';
          isSaving = false;
          notifyListeners();
          return false;
        }

        photoUrlController.text = photoUrlForPayload;
      }

      final request = AddStudentRequest(
        schoolId: selectedSchoolId!,
        studentName: studentNameController.text.trim(),
        studentClass: selectedClass,
        section: sectionController.text.trim().isNotEmpty
            ? sectionController.text.trim()
            : null,
        rollNumber: rollNumberController.text.trim().isNotEmpty
            ? rollNumberController.text.trim()
            : null,
        photoUrl: photoUrlForPayload,
        dateOfBirth: dateOfBirthController.text.trim().isNotEmpty
            ? dateOfBirthController.text.trim()
            : null,
        gender: selectedGender,
        pickupAddressId: selectedPickupAddressId!,
        emergencyContact: emergencyContactController.text.trim().isNotEmpty
            ? emergencyContactController.text.trim()
            : null,
        medicalInfo: medicalInfoController.text.trim().isNotEmpty
            ? medicalInfoController.text.trim()
            : null,
      );

      final studentService = StudentService(ApiClient());
      final payload = request.toJson();

      final response = isEditMode
          ? await studentService.updateStudent(currentStudent!.id!, payload)
          : await studentService.createStudent(payload);

      if (response['success']) {
        // Refresh student list
        await fetchStudents();
        clearForm();
        isSaving = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response['error'] ?? 'Failed to add student';
        isSaving = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
      isSaving = false;
      notifyListeners();
      return false;
    }
  }

  // Photo selection methods
  Future<void> selectPhotoFromGallery() async {
    await _pickPhoto(ImageSource.gallery);
  }

  Future<void> selectPhotoFromCamera() async {
    await _pickPhoto(ImageSource.camera);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 85);

      if (pickedFile == null) return;

      selectedPhotoFile = File(pickedFile.path);
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to select photo';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    studentNameController.dispose();
    sectionController.dispose();
    rollNumberController.dispose();
    photoUrlController.dispose();
    dateOfBirthController.dispose();
    emergencyContactController.dispose();
    medicalInfoController.dispose();
    super.dispose();
  }
}
