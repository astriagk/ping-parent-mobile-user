import 'package:http/http.dart' as http;
import '../helper/auth_helper.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> get(String url, {bool requiresAuth = true}) async {
    final headers = <String, String>{};

    if (requiresAuth) {
      final token = await AuthHelper.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return await _client.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers,
      Object? body,
      bool requiresAuth = true}) async {
    final finalHeaders = <String, String>{
      'Content-Type': 'application/json',
      ...?headers,
    };

    if (requiresAuth) {
      final token = await AuthHelper.getToken();
      if (token != null) {
        finalHeaders['Authorization'] = 'Bearer $token';
      }
    }

    return await _client.post(Uri.parse(url),
        headers: finalHeaders, body: body);
  }

  // Add put, delete, etc. as needed
}
