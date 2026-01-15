import '../api_client.dart';
import '../endpoints.dart';
import '../models/student_response.dart';
import '../models/school_response.dart';
import '../models/parent_address_response.dart';
import 'dart:convert';

class StudentService {
  final ApiClient _apiClient;

  StudentService(this._apiClient);

  Future<StudentListResponse> getMyStudents() async {
    final response = await _apiClient.get(Endpoints.myStudents);

    if (response.statusCode == 200) {
      return StudentListResponse.fromJson(jsonDecode(response.body));
    } else {
      return StudentListResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<Map<String, dynamic>> createStudent(
      Map<String, dynamic> studentData) async {
    final response = await _apiClient.post(
      Endpoints.students,
      body: studentData,
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'data': responseData,
        'message': responseData['message'] ?? 'Student added successfully',
      };
    } else {
      // Handle validation errors with details
      String errorMessage = responseData['error'] ??
          responseData['message'] ??
          'Failed to add student';

      // If there are validation details, append them
      if (responseData['details'] != null && responseData['details'] is List) {
        final details = (responseData['details'] as List).join('\n');
        errorMessage = '$errorMessage\n$details';
      }

      return {
        'success': false,
        'error': errorMessage,
      };
    }
  }

  Future<SchoolListResponse> getSchools() async {
    final response = await _apiClient.get(Endpoints.schools);

    if (response.statusCode == 200) {
      return SchoolListResponse.fromJson(jsonDecode(response.body));
    } else {
      return SchoolListResponse.fromJson(
          {'success': false, 'data': [], 'message': 'Failed to fetch schools'});
    }
  }

  Future<ParentAddressResponse?> getParentAddress() async {
    final response = await _apiClient.get(Endpoints.parentAddress);

    if (response.statusCode == 200) {
      return ParentAddressResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
