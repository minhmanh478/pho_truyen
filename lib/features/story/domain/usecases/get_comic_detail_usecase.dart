import 'package:pho_truyen/features/story/data/models/comic_model.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class GetComicDetailUseCase {
  final ComicRepository repository;

  GetComicDetailUseCase({required this.repository});

  Future<ComicDetailModel> call(int id) async {
    return await repository.getComicDetail(id);
  }
}
