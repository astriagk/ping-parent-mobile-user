import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/storage_service.dart';

class ApiClient {
  final http.Client _client;
  final StorageService _storage = StorageService();

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Get headers with authentication token if available
  Future<Map<String, String>> getHeaders(
      {Map<String, String>? additionalHeaders}) async {
    final token = await _storage.getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.get(Uri.parse(url), headers: requestHeaders);
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers, Object? body}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.post(
      Uri.parse(url),
      headers: requestHeaders,
      body: body is Map ? json.encode(body) : body,
    );
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers, Object? body}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.put(
      Uri.parse(url),
      headers: requestHeaders,
      body: body is Map ? json.encode(body) : body,
    );
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.delete(Uri.parse(url), headers: requestHeaders);
  }

  Future<http.Response> patch(String url,
      {Map<String, String>? headers, Object? body}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.patch(
      Uri.parse(url),
      headers: requestHeaders,
      body: body is Map ? json.encode(body) : body,
    );
  }

  Future<http.Response> multipart(
    String method,
    String url, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
  }) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    // Let MultipartRequest set its own Content-Type with boundary.
    requestHeaders.remove('Content-Type');

    final request = http.MultipartRequest(method, Uri.parse(url))
      ..headers.addAll(requestHeaders);

    if (fields != null && fields.isNotEmpty) {
      request.fields.addAll(fields);
    }

    if (files != null && files.isNotEmpty) {
      request.files.addAll(files);
    }

    final streamedResponse = await _client.send(request);
    return http.Response.fromStream(streamedResponse);
  }
}
