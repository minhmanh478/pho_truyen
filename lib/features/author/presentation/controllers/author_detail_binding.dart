import 'package:get/get.dart';
import 'package:pho_truyen/features/author/data/datasources/author_remote_data_source.dart';
import 'package:pho_truyen/features/author/data/repositories/author_repository_impl.dart';
import 'package:pho_truyen/features/author/domain/usecases/get_author_detail_usecase.dart';
import 'package:pho_truyen/features/author/domain/usecases/get_stories_by_author_usecase.dart';
import 'package:pho_truyen/features/author/presentation/controllers/author_detail_controller.dart';

class AuthorDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorRemoteDataSource>(() => AuthorRemoteDataSourceImpl());
    Get.lazyPut(() => AuthorRepositoryImpl(remoteDataSource: Get.find()));
    Get.lazyPut(() => GetAuthorDetailUseCase(Get.find<AuthorRepositoryImpl>()));
    Get.lazyPut(
      () => GetStoriesByAuthorUseCase(Get.find<AuthorRepositoryImpl>()),
    );
    Get.lazyPut(
      () => AuthorDetailController(
        getAuthorDetailUseCase: Get.find(),
        getStoriesByAuthorUseCase: Get.find(),
      ),
    );
  }
}
