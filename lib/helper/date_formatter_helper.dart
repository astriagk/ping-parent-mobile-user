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
}
