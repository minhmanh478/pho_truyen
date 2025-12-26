import 'package:pho_truyen/features/chapter/domain/repositories/chapter_repository.dart';
import 'package:pho_truyen/core/network/base_response.dart';

class BuyChapterUseCase {
  final ChapterRepository repository;

  BuyChapterUseCase(this.repository);

  Future<BaseResponse> call(int id) {
    return repository.buyChapter(id);
  }
}
