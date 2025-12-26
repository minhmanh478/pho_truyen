import 'package:pho_truyen/features/author/domain/repositories/author_repository.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';

class GetStoriesByAuthorUseCase {
  final AuthorRepository repository;

  GetStoriesByAuthorUseCase(this.repository);

  Future<List<StoryModel>> call(int userId, int offset, int limit) {
    return repository.getStoriesByAuthor(userId, offset, limit);
  }
}
