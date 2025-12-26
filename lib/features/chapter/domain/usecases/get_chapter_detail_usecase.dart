import 'package:pho_truyen/features/chapter/data/models/chapter_model.dart';
import 'package:pho_truyen/features/chapter/domain/repositories/chapter_repository.dart';

class GetChapterDetailUseCase {
  final ChapterRepository repository;

  GetChapterDetailUseCase(this.repository);

  Future<ChapterDetailResponse> call(int id) async {
    return await repository.getChapterDetail(id);
  }
}
