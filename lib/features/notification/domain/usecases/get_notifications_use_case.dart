import '../repositories/notification_repository.dart';
import '../entities/notification_result.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<NotificationResult> call(int offset, int limit) {
    return _repository.getNotifications(offset, limit);
  }
}
