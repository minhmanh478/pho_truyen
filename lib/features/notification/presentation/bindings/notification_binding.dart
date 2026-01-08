import 'package:get/get.dart';
import 'package:pho_truyen/features/notification/domain/repositories/notification_repository.dart';
import '../controllers/notification_controller.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/read_notification_usecase.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/datasources/notification_remote_data_source.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(),
    );
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(
        remoteDataSource: Get.find<NotificationRemoteDataSource>(),
      ),
    );
    Get.lazyPut(() => GetNotificationsUseCase(Get.find()));
    Get.lazyPut(() => DeleteNotificationUseCase(Get.find()));
    Get.lazyPut(() => ReadNotificationUseCase(Get.find()));
    Get.lazyPut(
      () => NotificationController(
        getNotificationsUseCase: Get.find(),
        deleteNotificationUseCase: Get.find(),
        readNotificationUseCase: Get.find(),
      ),
    );
  }
}
