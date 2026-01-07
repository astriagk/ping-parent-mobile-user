import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> get(String url) async {
    return await _client.get(Uri.parse(url));
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers, Object? body}) async {
    return await _client.post(Uri.parse(url), headers: headers, body: body);
  }

  // Add put, delete, etc. as needed
}
