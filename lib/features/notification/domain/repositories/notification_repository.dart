import '../entities/notification_result.dart';

abstract class NotificationRepository {
  Future<NotificationResult> getNotifications(int offset, int limit);
  Future<bool> deleteNotification(int id);
  Future<bool> readNotification(int id);
}
