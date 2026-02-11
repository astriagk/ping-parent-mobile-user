enum TripType {
  pickup('pickup'),
  drop('drop');

  final String value;

  const TripType(this.value);

  static TripType fromString(String? value) {
    return TripType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TripType.pickup,
    );
  }

  String toDisplayString() {
    switch (this) {
      case TripType.pickup:
        return 'Pickup';
      case TripType.drop:
        return 'Drop';
    }
  }
}
