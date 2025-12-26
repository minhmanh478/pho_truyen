import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/login_remote_datasource.dart';
import '../../data/datasources/register_remote_datasource.dart';
import '../../data/datasources/forgot_password_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/request_forgot_password_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/verify_code_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import 'forgot_password_controller.dart';
import 'login_controller.dart';
import 'register_controller.dart';
import 'reset_password_controller.dart';
import 'verify_code_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(dioClient: DioClient()),
    );
    Get.lazyPut<RegisterRemoteDataSource>(
      () => RegisterRemoteDataSourceImpl(dioClient: DioClient()),
    );
    Get.lazyPut<ForgotPasswordRemoteDataSource>(
      () => ForgotPasswordRemoteDataSourceImpl(dioClient: DioClient()),
    );

    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        loginRemoteDataSource: Get.find(),
        registerRemoteDataSource: Get.find(),
        forgotPasswordRemoteDataSource: Get.find(),
      ),
    );

    // Use Cases
    Get.lazyPut(() => LoginUseCase(Get.find()));
    Get.lazyPut(() => RegisterUseCase(Get.find()));
    Get.lazyPut(() => RequestForgotPasswordUseCase(Get.find()));
    Get.lazyPut(() => VerifyCodeUseCase(Get.find()));
    Get.lazyPut(() => UpdatePasswordUseCase(Get.find()));
    Get.lazyPut(() => RefreshTokenUseCase(Get.find()));

    // Controllers
    Get.lazyPut(() => LoginController(loginUseCase: Get.find()));
    Get.lazyPut(() => RegisterController(registerUseCase: Get.find()));
    Get.lazyPut(
      () => ForgotPasswordController(requestForgotPasswordUseCase: Get.find()),
    );
    Get.lazyPut(
      () => VerifyCodeController(
        verifyCodeUseCase: Get.find(),
        requestForgotPasswordUseCase: Get.find(),
      ),
    );
    Get.lazyPut(
      () => ResetPasswordController(updatePasswordUseCase: Get.find()),
    );
  }
}
