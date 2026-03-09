import 'dart:io';

import 'package:http/http.dart' as http;

import '../api_client.dart';
import '../endpoints.dart';
// import '../models/user_model.dart';
import '../models/profile_response.dart';
import '../interfaces/user_service_interface.dart';
import 'dart:convert';

class UserService implements UserServiceInterface {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  @override
  // Future<UserModel> fetchUser() async {
  //   final response = await _apiClient.get(Endpoints.getUser);
  //   if (response.statusCode == 200) {
  //     return UserModel.fromJson(
  //       // ignore: unnecessary_cast
  //       (response.body as Map<String, dynamic>),
  //     );
  //   } else {
  //     throw Exception('Failed to load user');
  //   }
  // }

  @override
  Future<ProfileResponse> getParentProfile() async {
    final response = await _apiClient.get(Endpoints.parentProfile);
    if (response.statusCode == 200) {
      return ProfileResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = ProfileResponse.fromJson(jsonDecode(response.body));
      throw Exception(errorResponse.data ?? 'Failed to load profile');
    }
  }

  @override
  Future<ProfileResponse> updateParentProfile({
    String? name,
    String? email,
    String? photoUrl,
  }) async {
    final Map<String, dynamic> payload = {};

    if (name != null) payload['name'] = name;
    if (email != null) payload['email'] = email;
    if (photoUrl != null) payload['photo_url'] = photoUrl;

    final response = await _apiClient.put(
      Endpoints.parentProfile,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return ProfileResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Failed to update profile');
    }
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
}
