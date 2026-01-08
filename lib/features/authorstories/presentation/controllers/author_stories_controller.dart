import 'package:get/get.dart';
import '../../data/models/user_story_request.dart';
import '../../domain/entities/user_story_entity.dart';
import '../../domain/usecases/get_user_stories_usecase.dart';

class AuthorStoriesController extends GetxController {
  final GetUserStoriesUseCase getUserStoriesUseCase;

  AuthorStoriesController({required this.getUserStoriesUseCase});

  final RxList<UserStoryEntity> stories = <UserStoryEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStories();
  }

  Future<void> fetchStories() async {
    isLoading.value = true;
    errorMessage.value = '';

    final request = UserStoryRequest(limit: 20, offset: 0);

    final result = await getUserStoriesUseCase(request);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (data) {
        stories.assignAll(data);
        isLoading.value = false;
      },
    );
  }
}
