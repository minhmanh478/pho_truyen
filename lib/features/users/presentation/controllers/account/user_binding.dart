import 'package:get/get.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/datasources/user_remote_datasource.dart';
import '../../../data/repositories/user_repository_impl.dart';
import '../../../domain/usecases/change_password_usecase.dart';
import '../../../domain/usecases/get_user_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';
import 'user_controller.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../../common/data/datasources/common_remote_datasource.dart';
import '../../../../common/data/repositories/common_repository_impl.dart';
import '../../../../common/domain/repositories/common_repository.dart';
import '../../../../common/domain/usecases/upload_image_usecase.dart';

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
    Get.lazyPut<CommonRemoteDataSource>(
      () => CommonRemoteDataSourceImpl(dioClient: Get.find()),
    );
    Get.lazyPut<CommonRepository>(
      () => CommonRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => UploadImageUseCase(Get.find()));

    Get.lazyPut(
      () => UserController(
        getUserProfileUseCase: Get.find(),
        updateProfileUseCase: Get.find(),
        changePasswordUseCase: Get.find(),
        uploadImageUseCase: Get.find(),
      ),
    );
  }
}
