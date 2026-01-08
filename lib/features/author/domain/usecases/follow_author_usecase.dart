import 'package:pho_truyen/features/author/domain/repositories/author_repository.dart';

class FollowAuthorUseCase {
  final AuthorRepository repository;

  FollowAuthorUseCase(this.repository);

  Future<bool> call(int id, int state) async {
    return await repository.followAuthor(id, state);
  }
}
