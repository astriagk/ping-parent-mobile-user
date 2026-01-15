import 'package:taxify_user_ui/config.dart';
import '../../api/api_client.dart';
import '../../api/services/student_service.dart';
import '../../api/models/student_response.dart';

class AddStudentProvider extends ChangeNotifier {
  List<Student> studentList = [];
  bool isLoading = false;
  String? errorMessage;

  // Edit mode
  bool isEditMode = false;
  int? editIndex;
  Student? currentStudent;

  Future<void> onInit() async {
    await fetchStudents();
  }

  Future<void> fetchStudents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final studentService = StudentService(ApiClient());
      final response = await studentService.getMyStudents();

      if (response.success) {
        studentList = response.data;
        errorMessage = null;
      } else {
        errorMessage = response.error ?? response.message ?? 'Failed to fetch students';
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
    notifyListeners();
  }

  // Set form for editing existing student
  setEditStudent(int index) {
    currentStudent = studentList[index];
    isEditMode = true;
    editIndex = index;
    notifyListeners();
  }
}
