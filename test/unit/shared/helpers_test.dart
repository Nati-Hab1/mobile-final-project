import 'package:flutter_test/flutter_test.dart';

// Helper function for date formatting
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

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

String formatDate(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

void main() {
  group('DateHelpers - formatTimeAgo', () {
    test('returns "Just now" for current time', () {
      final now = DateTime.now();
      expect(formatTimeAgo(now), 'Just now');
    });

    test('returns "1 minute ago" for 1 minute difference',
        () {
      final oneMinuteAgo = DateTime.now()
          .subtract(const Duration(minutes: 1));
      expect(formatTimeAgo(oneMinuteAgo), '1 minute ago');
    });

    test('returns "1 hour ago" for 1 hour difference', () {
      final oneHourAgo =
          DateTime.now().subtract(const Duration(hours: 1));
      expect(formatTimeAgo(oneHourAgo), '1 hour ago');
    });

    test('returns "1 day ago" for 1 day difference', () {
      final oneDayAgo =
          DateTime.now().subtract(const Duration(days: 1));
      expect(formatTimeAgo(oneDayAgo), '1 day ago');
    });
  });

  group('DateHelpers - formatDate', () {
    test('formats date correctly', () {
      final date = DateTime(2024, 12, 25);
      expect(formatDate(date), '25/12/2024');
    });
  });
}
