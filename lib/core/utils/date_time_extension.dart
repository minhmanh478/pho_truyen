import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} tuần trước';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(this);
    }
  }
}

extension StringDateExtension on String {
  String get timeAgo {
    if (isEmpty) return '';
    try {
      final dateTime = DateTime.parse(this).toLocal();
      return dateTime.timeAgo;
    } catch (e) {
      return this;
    }
  }
}
