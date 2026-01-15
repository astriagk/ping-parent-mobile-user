class ParentAddressResponse {
  final bool success;
  final ParentAddress data;

  ParentAddressResponse({
    required this.success,
    required this.data,
  });

  factory ParentAddressResponse.fromJson(Map<String, dynamic> json) {
    return ParentAddressResponse(
      success: json['success'] ?? false,
      data: ParentAddress.fromJson(json['data'] ?? {}),
    );
  }
}

class ParentAddress {
  final String id;
  final String parentId;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final bool isPrimary;
  final String createdAt;
  final String updatedAt;

  ParentAddress({
    required this.id,
    required this.parentId,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParentAddress.fromJson(Map<String, dynamic> json) {
    return ParentAddress(
      id: json['_id'] ?? '',
      parentId: json['parent_id'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      isPrimary: json['is_primary'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  // Display format for dropdown
  String get displayAddress {
    return '$addressLine1, ${addressLine2.isNotEmpty ? '$addressLine2, ' : ''}$city, $state - $pincode';
  }
}
