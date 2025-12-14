import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Format date to "Monday, 25 Dec"
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, d MMM').format(date);
  }

  /// Format time to "3:30 PM"
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format to "Mon"
  static String formatDayShort(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  /// Format to "3 PM"
  static String formatHourShort(DateTime date) {
    return DateFormat('h a').format(date);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}