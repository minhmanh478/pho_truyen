import 'package:pho_truyen/core/network/api_client.dart';
import '../models/get_notification_response.dart';

abstract class NotificationRemoteDataSource {
  Future<GetNotificationResponse> getNotifications(int offset, int limit);
  Future<bool> deleteNotification(int id);
  Future<bool> readNotification(int id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _dioClient;

  NotificationRemoteDataSourceImpl({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  @override
  Future<GetNotificationResponse> getNotifications(
    int offset,
    int limit,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/notification/list',
        data: {'offset': offset, 'limit': limit},
      );
      return GetNotificationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteNotification(int id) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/notification/delete',
        data: {'id': id},
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> readNotification(int id) async {
    try {
      final response = await _dioClient.dio.post(
        '/api/notification/read',
        data: {'id': id},
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
