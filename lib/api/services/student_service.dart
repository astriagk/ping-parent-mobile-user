import '../api_client.dart';
import '../endpoints.dart';
import '../interfaces/student_service_interface.dart';
import '../models/student_response.dart';
import '../models/school_response.dart';
import '../models/parent_address_response.dart';
import 'dart:convert';

class StudentService implements StudentServiceInterface {
  final ApiClient _apiClient;

  StudentService(this._apiClient);

  Map<String, String> get _jsonHeaders => {'Content-Type': 'application/json'};

  Map<String, dynamic> _handleMutationResponse(
      dynamic response, String successMessage, String errorMessage) {
    final responseData = jsonDecode(response.body);
    final isSuccess =
        response.statusCode == 200 || response.statusCode == 201;

    if (isSuccess) {
      return {
        'success': true,
        'data': responseData,
        'message': responseData['message'] ?? successMessage,
      };
    }

    String error =
        responseData['error'] ?? responseData['message'] ?? errorMessage;

    if (responseData['details'] != null && responseData['details'] is List) {
      error = '$error\n${(responseData['details'] as List).join('\n')}';
    }

    return {'success': false, 'error': error};
  }

  @override
  Future<StudentListResponse> getMyStudents() async {
    final response = await _apiClient.get(Endpoints.myStudents);
    return StudentListResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<Map<String, dynamic>> createStudent(
      Map<String, dynamic> studentData) async {
    final response = await _apiClient.post(
      Endpoints.students,
      headers: _jsonHeaders,
      body: jsonEncode(studentData),
    );
    return _handleMutationResponse(
        response, 'Student added successfully', 'Failed to add student');
  }

  @override
  Future<Map<String, dynamic>> updateStudent(
      String studentId, Map<String, dynamic> studentData) async {
    final response = await _apiClient.put(
      Endpoints.updateStudent(studentId),
      headers: _jsonHeaders,
      body: jsonEncode(studentData),
    );
    return _handleMutationResponse(
        response, 'Student updated successfully', 'Failed to update student');
  }

  @override
  Future<SchoolListResponse> getSchools() async {
    final response = await _apiClient.get(Endpoints.schools);
    if (response.statusCode == 200) {
      return SchoolListResponse.fromJson(jsonDecode(response.body));
    }
    return SchoolListResponse.fromJson(
        {'success': false, 'data': [], 'message': 'Failed to fetch schools'});
  }

  @override
  Future<ParentAddressResponse?> getParentAddress() async {
    final response = await _apiClient.get(Endpoints.parentAddress);
    if (response.statusCode == 200) {
      return ParentAddressResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
