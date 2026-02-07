enum TripStatus {
  scheduled('scheduled'),
  started('started'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled');

  final String value;

  const TripStatus(this.value);

  static TripStatus fromString(String? value) {
    return TripStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TripStatus.scheduled,
    );
  }

  String toDisplayString() {
    switch (this) {
      case TripStatus.scheduled:
        return 'Scheduled';
      case TripStatus.started:
        return 'Started';
      case TripStatus.inProgress:
        return 'In Progress';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.cancelled:
        return 'Cancelled';
    }
  }
}
