import 'package:get/get.dart';
import '../controllers/main_app_controller.dart';
import 'package:pho_truyen/features/story/presentation/controllers/library_controller.dart';
import '../../../../core/network/api_client.dart';
import '../../../search/data/datasources/search_remote_datasource.dart';
import '../../../search/data/repositories/search_repository_impl.dart';
import '../../../search/domain/repositories/search_repository.dart';
import '../../../search/domain/usecases/search_stories_usecase.dart';
import '../../../auth/data/datasources/login_remote_datasource.dart';
import '../../../auth/data/datasources/register_remote_datasource.dart';
import '../../../auth/data/datasources/forgot_password_remote_datasource.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/usecases/refresh_token_usecase.dart';

class MainAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAppController>(() => MainAppController());
    Get.lazyPut(() => DioClient(), fenix: true);

    // Search Dependencies
    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(dioClient: Get.find()),
    );
    Get.lazyPut<SearchRepository>(
      () => SearchRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => SearchStoriesUseCase(Get.find()));

    Get.lazyPut<LibraryController>(
      () => LibraryController(searchStoriesUseCase: Get.find()),
    );

    // Auth Dependencies for Token Refresh
    Get.lazyPut<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(dioClient: Get.find()),
    );
    // Mock/Empty implementations for unused datasources if possible, or just real ones
    Get.lazyPut<RegisterRemoteDataSource>(
      () => RegisterRemoteDataSourceImpl(dioClient: Get.find()),
    );
    Get.lazyPut<ForgotPasswordRemoteDataSource>(
      () => ForgotPasswordRemoteDataSourceImpl(dioClient: Get.find()),
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        loginRemoteDataSource: Get.find(),
        registerRemoteDataSource: Get.find(),
        forgotPasswordRemoteDataSource: Get.find(),
      ),
    );
    Get.lazyPut(() => RefreshTokenUseCase(Get.find()));
  }
}
