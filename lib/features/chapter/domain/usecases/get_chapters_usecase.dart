import 'package:pho_truyen/features/chapter/domain/repositories/chapter_repository.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';

class GetChaptersUseCase {
  final ChapterRepository repository;

  GetChaptersUseCase(this.repository);

  Future<ComicChaptersResponse> call(int storyId) async {
    return await repository.getChapters(storyId);
  }
}
