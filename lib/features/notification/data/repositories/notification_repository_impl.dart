import '../../domain/repositories/notification_repository.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/notification_result.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl({NotificationRemoteDataSource? remoteDataSource})
    : _remoteDataSource =
          remoteDataSource ?? NotificationRemoteDataSourceImpl();

  @override
  Future<NotificationResult> getNotifications(int offset, int limit) async {
    try {
      final response = await _remoteDataSource.getNotifications(offset, limit);
      final data = response.data;
      if (data == null) {
        return NotificationResult([], 0);
      }

      final entities = data.items
          .map(
            (model) => NotificationEntity(
              id: model.id,
              title: model.title,
              content: model.content,
              image: model.image,
              isRead: model.isRead == 1,
              type: model.type,
              payload: model.payload,
              timeCreate: DateTime.tryParse(model.timeCreate),
              linkMobile: model.linkMobile,
            ),
          )
          .toList();

      return NotificationResult(entities, data.total);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteNotification(int id) async {
    return await _remoteDataSource.deleteNotification(id);
  }

  @override
  Future<bool> readNotification(int id) async {
    return await _remoteDataSource.readNotification(id);
  }
}
