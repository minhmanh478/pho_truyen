import 'package:pho_truyen/features/story/data/models/story_tag_model.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class GetStoryTagsUseCase {
  final ComicRepository repository;

  GetStoryTagsUseCase({required this.repository});

  Future<List<StoryTagModel>> call() async {
    return await repository.getStoryTags();
  }
}
