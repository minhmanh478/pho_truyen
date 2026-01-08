import 'package:get/get.dart';
import '../../data/datasources/author_stories_remote_datasource.dart';
import '../../data/repositories/author_stories_repository_impl.dart';
import '../../domain/repositories/author_stories_repository.dart';
import '../../domain/usecases/get_user_stories_usecase.dart';
import 'author_stories_controller.dart';

class AuthorStoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorStoriesRemoteDataSource>(
      () => AuthorStoriesRemoteDataSourceImpl(dioClient: Get.find()),
    );
    Get.lazyPut<AuthorStoriesRepository>(
      () => AuthorStoriesRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => GetUserStoriesUseCase(Get.find()));
    Get.lazyPut(
      () => AuthorStoriesController(getUserStoriesUseCase: Get.find()),
    );
  }
}
