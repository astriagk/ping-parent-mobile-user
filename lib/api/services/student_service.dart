import '../api_client.dart';
import '../endpoints.dart';
import '../models/student_response.dart';
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
      return {
        'success': false,
        'error': responseData['error'] ??
            responseData['message'] ??
            'Failed to add student',
      };
    }
  }
}
