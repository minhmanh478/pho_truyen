import '../repositories/notification_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository _repository;

  DeleteNotificationUseCase(this._repository);

  Future<bool> call(int id) async {
    return await _repository.deleteNotification(id);
  }
}
