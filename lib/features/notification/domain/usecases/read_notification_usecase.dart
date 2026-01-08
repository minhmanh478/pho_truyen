import '../repositories/notification_repository.dart';

class ReadNotificationUseCase {
  final NotificationRepository repository;

  ReadNotificationUseCase(this.repository);

  Future<bool> call(int id) async {
    return await repository.readNotification(id);
  }
}
