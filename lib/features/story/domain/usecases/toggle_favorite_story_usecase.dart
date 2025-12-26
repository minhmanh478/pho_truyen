import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class ToggleFavoriteStoryUseCase {
  final ComicRepository repository;

  ToggleFavoriteStoryUseCase(this.repository);

  Future<bool> call(int storyId, int state) async {
    return await repository.toggleFavoriteStory(storyId, state);
  }
}
