import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class GetViewedStoriesUseCase {
  final ComicRepository repository;

  GetViewedStoriesUseCase(this.repository);

  Future<List<StoryModel>> call(int userId, {int offset = 0, int limit = 20}) {
    return repository.getViewedStories(userId, offset: offset, limit: limit);
  }
}
