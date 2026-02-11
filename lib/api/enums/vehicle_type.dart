enum VehicleType {
  van('van'),
  auto('auto'),
  bus('bus');

  final String value;

  const VehicleType(this.value);

  static VehicleType fromString(String? value) {
    return VehicleType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VehicleType.auto,
    );
  }

  String toDisplayString() {
    switch (this) {
      case VehicleType.van:
        return 'Van';
      case VehicleType.auto:
        return 'Auto';
      case VehicleType.bus:
        return 'Bus';
    }
  }
}
