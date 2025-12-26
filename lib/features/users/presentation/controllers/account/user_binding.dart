import 'package:get/get.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/datasources/user_remote_datasource.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/usecases/change_password_usecase.dart';
import '../../../domain/usecases/get_user_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';
import 'user_controller.dart';
// Đừng quên import UserRepository (abstract class) nếu chưa import
import '../../../domain/repositories/user_repository.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(dioClient: DioClient()),
    );
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => GetUserProfileUseCase(Get.find()));
    Get.lazyPut(() => UpdateProfileUseCase(Get.find()));
    Get.lazyPut(() => ChangePasswordUseCase(Get.find()));
    Get.lazyPut(
      () => UserController(
        getUserProfileUseCase: Get.find(),
        updateProfileUseCase: Get.find(),
        changePasswordUseCase: Get.find(),
      ),
    );
  }
}
