import 'package:intl/intl.dart';

class DateHelpers {
  static final DateFormat _defaultFormat = DateFormat('yyyy-MM-dd HH:mm');

  static String format(DateTime date, {String? pattern}) {
    if (pattern != null) {
      return DateFormat(pattern).format(date);
    }
    return _defaultFormat.format(date);
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return format(date);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
