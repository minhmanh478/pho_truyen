import 'package:pho_truyen/features/author/data/models/author_model.dart';
import 'package:pho_truyen/features/author/domain/repositories/author_repository.dart';

class GetAuthorDetailUseCase {
  final AuthorRepository repository;

  GetAuthorDetailUseCase(this.repository);

  Future<AuthorDetailData> call(int id) {
    return repository.getAuthorDetail(id);
  }
}
