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
import '../../../home/data/datasources/home_remote_data_source.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/domain/usecases/get_home_usecase.dart';
import '../../../home/presentation/controllers/home_controller.dart';

class MainAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAppController>(() => MainAppController());
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);

    // Search Dependencies
    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
    );
    Get.lazyPut<SearchRepository>(
      () => SearchRepositoryImpl(
        remoteDataSource: Get.find<SearchRemoteDataSource>(),
      ),
    );
    Get.lazyPut<SearchStoriesUseCase>(
      () => SearchStoriesUseCase(Get.find<SearchRepository>()),
    );
    Get.lazyPut<LibraryController>(
      () => LibraryController(
        searchStoriesUseCase: Get.find<SearchStoriesUseCase>(),
      ),
    );

    Get.lazyPut<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
    );
    Get.lazyPut<RegisterRemoteDataSource>(
      () => RegisterRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
    );
    Get.lazyPut<ForgotPasswordRemoteDataSource>(
      () =>
          ForgotPasswordRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        loginRemoteDataSource: Get.find<LoginRemoteDataSource>(),
        registerRemoteDataSource: Get.find<RegisterRemoteDataSource>(),
        forgotPasswordRemoteDataSource:
            Get.find<ForgotPasswordRemoteDataSource>(),
      ),
    );
    Get.lazyPut<RefreshTokenUseCase>(
      () => RefreshTokenUseCase(Get.find<AuthRepository>()),
    );

    // Home Dependencies
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(dioClient: Get.find<DioClient>()),
    );
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: Get.find<HomeRemoteDataSource>(),
      ),
    );
    Get.lazyPut<GetHomeUseCase>(
      () => GetHomeUseCase(repository: Get.find<HomeRepository>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(getHomeUseCase: Get.find<GetHomeUseCase>()),
    );
  }
}
