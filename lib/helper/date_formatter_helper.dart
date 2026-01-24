class DateFormatterHelper {
  /// Format date to "15 Dec`23" format
  /// Takes ISO date string and returns formatted date
  static String? formatToShortDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      final dateTime = DateTime.parse(dateString);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final monthAbbr = months[dateTime.month - 1];
      final yearShort = dateTime.year.toString().substring(2);
      return '${dateTime.day} $monthAbbr`$yearShort';
    } catch (e) {
      return dateString;
    }
  }

  /// Format time to "02:30 PM" format (12-hour with AM/PM)
  /// Takes ISO date string and returns formatted time
  static String? formatTo12HourTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      final dateTime = DateTime.parse(dateString);
      final hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return null;
    }
  }
}
