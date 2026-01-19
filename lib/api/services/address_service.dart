import '../api_client.dart';
import '../endpoints.dart';
import '../models/parent_address_response.dart';
import 'dart:convert';

class AddressService {
  final ApiClient _apiClient;

  AddressService(this._apiClient);

  Map<String, String> get _jsonHeaders => {'Content-Type': 'application/json'};

  /// Save or update parent address
  /// Required fields: address_line1, city, state, latitude, longitude
  Future<Map<String, dynamic>> saveAddress({
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String pincode,
    required double latitude,
    required double longitude,
    bool isPrimary = true,
  }) async {
    final payload = {
      'address_line1': addressLine1,
      'address_line2': addressLine2 ?? '',
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'is_primary': isPrimary,
    };

    final response = await _apiClient.put(
      Endpoints.parentAddress,
      headers: _jsonHeaders,
      body: jsonEncode(payload),
    );

    final responseData = jsonDecode(response.body);
    final isSuccess = response.statusCode == 200 || response.statusCode == 201;

    if (isSuccess) {
      return {
        'success': true,
        'data': ParentAddress.fromJson(responseData['data'] ?? {}),
        'message': responseData['message'] ?? 'Address saved successfully',
      };
    }

    String error =
        responseData['error'] ?? responseData['message'] ?? 'Failed to save address';

    if (responseData['details'] != null && responseData['details'] is List) {
      error = '$error\n${(responseData['details'] as List).join('\n')}';
    }

    return {'success': false, 'error': error};
  }

  /// Get parent address
  Future<ParentAddressResponse?> getParentAddress() async {
    final response = await _apiClient.get(Endpoints.parentAddress);
    if (response.statusCode == 200) {
      return ParentAddressResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
