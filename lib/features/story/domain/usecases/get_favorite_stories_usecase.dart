import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class GetFavoriteStoriesUseCase {
  final ComicRepository repository;

  GetFavoriteStoriesUseCase(this.repository);

  Future<List<StoryModel>> call(
    int userId, {
    int offset = 0,
    int limit = 20,
  }) async {
    return await repository.getFavoriteStories(
      userId,
      offset: offset,
      limit: limit,
    );
  }
}
