import 'notification_model.dart';

class NotificationData {
  final List<NotificationModel> items;
  final int total;

  NotificationData({required this.items, required this.total});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      items: json['items'] != null
          ? (json['items'] as List)
                .map((i) => NotificationModel.fromJson(i))
                .toList()
          : [],
      total: json['total'] ?? 0,
    );
  }
}
