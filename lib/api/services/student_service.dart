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
}
