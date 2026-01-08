import 'package:get/get.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/read_notification_usecase.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationController extends GetxController {
  final GetNotificationsUseCase getNotificationsUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final ReadNotificationUseCase readNotificationUseCase;

  NotificationController({
    required this.getNotificationsUseCase,
    required this.deleteNotificationUseCase,
    required this.readNotificationUseCase,
  });

  final notifications = <NotificationEntity>[].obs;
  final isLoading = false.obs;
  final offset = 0.obs;
  final limit = 20;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      offset.value = 0;
      hasMore.value = true;
      notifications.clear();
    }

    if (!hasMore.value && !isRefresh) return;

    isLoading.value = true;

    try {
      final result = await getNotificationsUseCase(offset.value, limit);

      if (result.items.length < limit) {
        hasMore.value = false;
      }
      notifications.addAll(result.items);
      offset.value += result.items.length;
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final success = await deleteNotificationUseCase(id);
      if (success) {
        notifications.removeWhere((element) => element.id == id);
        Get.snackbar('Thành công', 'Đã xoá thông báo');
      } else {
        Get.snackbar('Thất bại', 'Không thể xoá thông báo');
      }
    } catch (e) {
      print('Error deleting notification: $e');
      Get.snackbar('Lỗi', 'Có lỗi xảy ra khi xoá thông báo');
    }
  }

  Future<void> readNotification(int id) async {
    try {
      final success = await readNotificationUseCase(id);
      if (success) {
        final index = notifications.indexWhere((element) => element.id == id);
        if (index != -1) {
          final notification = notifications[index];
          notifications[index] = NotificationEntity(
            id: notification.id,
            title: notification.title,
            content: notification.content,
            image: notification.image,
            isRead: true,
            type: notification.type,
            payload: notification.payload,
            timeCreate: notification.timeCreate,
            linkMobile: notification.linkMobile,
          );
        }
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}
