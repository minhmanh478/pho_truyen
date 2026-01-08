import 'notification_data.dart';

class GetNotificationResponse {
  final String code;
  final String message;
  final NotificationData? data;

  GetNotificationResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory GetNotificationResponse.fromJson(Map<String, dynamic> json) {
    return GetNotificationResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'])
          : null,
    );
  }
}
