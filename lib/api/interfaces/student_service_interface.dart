import '../models/student_response.dart';
import '../models/school_response.dart';
import '../models/parent_address_response.dart';

abstract class StudentServiceInterface {
  Future<StudentListResponse> getMyStudents();
  Future<Map<String, dynamic>> createStudent(Map<String, dynamic> studentData);
  Future<Map<String, dynamic>> updateStudent(
      String studentId, Map<String, dynamic> studentData);
  Future<SchoolListResponse> getSchools();
  Future<ParentAddressResponse?> getParentAddress();
}
