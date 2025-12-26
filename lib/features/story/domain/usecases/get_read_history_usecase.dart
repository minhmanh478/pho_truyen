import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class GetReadHistoryUseCase {
  final ComicRepository repository;

  GetReadHistoryUseCase(this.repository);

  Future<List<StoryModel>> call(int userId, {int offset = 0, int limit = 20}) {
    return repository.getReadHistory(userId, offset: offset, limit: limit);
  }
}
