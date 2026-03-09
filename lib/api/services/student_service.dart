import 'dart:io';

import 'package:http/http.dart' as http;

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
    final isSuccess = response.statusCode == 200 || response.statusCode == 201;

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
  Future<Map<String, dynamic>> uploadSharedFile({
    required File file,
    required String folderPath,
    String? oldFileUrl,
  }) async {
    try {
      final uploadEndpoint =
          '${Endpoints.sharedUpload}?folder_path=${Uri.encodeComponent(folderPath)}';

      final method =
          (oldFileUrl != null && oldFileUrl.trim().isNotEmpty) ? 'PUT' : 'POST';

      final fields = <String, String>{
        if (method == 'PUT') 'old_file_url': oldFileUrl!.trim(),
      };

      final multipartFile =
          await http.MultipartFile.fromPath('file', file.path);
      final response = await _apiClient.multipart(
        method,
        uploadEndpoint,
        fields: fields,
        files: [multipartFile],
      );

      Map<String, dynamic> body = {};
      if (response.body.isNotEmpty) {
        body = jsonDecode(response.body) as Map<String, dynamic>;
      }

      final successStatus =
          response.statusCode >= 200 && response.statusCode < 300;

      if (!successStatus) {
        return {
          'success': false,
          'url': null,
          'message': body['message'] ?? 'Failed to upload image',
          'error': body['error'] ?? response.body,
        };
      }

      final dynamic data = body['data'];
      String? uploadedUrl;

      if (data is Map<String, dynamic>) {
        uploadedUrl = (data['url'] ??
                data['file_url'] ??
                data['photo_url'] ??
                data['location'])
            ?.toString();
      }

      uploadedUrl ??=
          (body['url'] ?? body['file_url'] ?? body['photo_url'])?.toString();

      if (uploadedUrl == null || uploadedUrl.isEmpty) {
        return {
          'success': false,
          'url': null,
          'message': body['message'] ?? 'Upload succeeded but URL not found',
          'error': 'Missing uploaded file URL in response',
        };
      }

      return {
        'success': true,
        'url': uploadedUrl,
        'message': body['message'] ?? 'File uploaded successfully',
        'error': null,
      };
    } catch (e) {
      return {
        'success': false,
        'url': null,
        'message': 'Failed to upload image',
        'error': e.toString(),
      };
    }
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
