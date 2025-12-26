import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class GetStoriesUseCase {
  final ComicRepository repository;

  GetStoriesUseCase({required this.repository});

  Future<List<StoryModel>> call({
    String? search,
    String? order,
    String? categoryId,
    String? tag,
    String? state,
    String? chapterMin,
    String? chapterMax,
    String? timeUpdate,
    int offset = 0,
    int limit = 20,
    String? sort,
    String? code,
  }) async {
    return await repository.getStories(
      search: search,
      order: order,
      categoryId: categoryId,
      tag: tag,
      state: state,
      chapterMin: chapterMin,
      chapterMax: chapterMax,
      timeUpdate: timeUpdate,
      offset: offset,
      limit: limit,
      sort: sort,
      code: code,
    );
  }
}
