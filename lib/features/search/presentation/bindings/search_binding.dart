import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/search_stories_usecase.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(dioClient: DioClient()),
    );
    Get.lazyPut<SearchRepository>(
      () => SearchRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => SearchStoriesUseCase(Get.find()));
    Get.lazyPut(() => SearchController(searchStoriesUseCase: Get.find()));
  }
}
