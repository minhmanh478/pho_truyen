import 'package:get/get.dart';
import 'package:pho_truyen/features/authorstories/data/datasources/author_stories_remote_datasource.dart';
import 'package:pho_truyen/features/authorstories/data/repositories/author_stories_repository_impl.dart';
import 'package:pho_truyen/features/authorstories/domain/repositories/author_stories_repository.dart';
import 'package:pho_truyen/features/authorstories/domain/usecases/create_story_usecase.dart';
import 'edit_story_controller.dart';
import 'package:pho_truyen/features/common/domain/usecases/upload_image_usecase.dart';
import 'package:pho_truyen/features/common/data/datasources/common_remote_datasource.dart';
import 'package:pho_truyen/features/common/data/repositories/common_repository_impl.dart';
import 'package:pho_truyen/features/common/domain/repositories/common_repository.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_filter_settings_usecase.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_story_tags_usecase.dart';
import 'package:pho_truyen/features/story/data/datasources/comic_remote_data_source.dart';
import 'package:pho_truyen/features/story/data/repositories/comic_repository_impl.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class EditStoryBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Author Stories Domain
    Get.lazyPut<AuthorStoriesRemoteDataSource>(
      () => AuthorStoriesRemoteDataSourceImpl(dioClient: Get.find()),
    );
    Get.lazyPut<AuthorStoriesRepository>(
      () => AuthorStoriesRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => CreateStoryUseCase(Get.find()));

    // 2. Comic Domain
    Get.lazyPut<ComicRemoteDataSource>(
      () => ComicRemoteDataSourceImpl(dioClient: Get.find()),
    );
    Get.lazyPut<ComicRepository>(
      () => ComicRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => GetStoryTagsUseCase(repository: Get.find()));
    Get.lazyPut(() => GetFilterSettingsUseCase(repository: Get.find()));

    // 3. image
    Get.lazyPut<CommonRemoteDataSource>(
      () => CommonRemoteDataSourceImpl(dioClient: Get.find()),
    );
    Get.lazyPut<CommonRepository>(
      () => CommonRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => UploadImageUseCase(Get.find()));

    // Controller
    Get.lazyPut<EditStoryController>(
      () => EditStoryController(
        createStoryUseCase: Get.find(),
        getStoryTagsUseCase: Get.find(),
        getFilterSettingsUseCase: Get.find(),
        uploadImageUseCase: Get.find(),
      ),
    );
  }
}
