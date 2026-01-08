import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/author_story_detail_entity.dart';
import '../repositories/author_stories_repository.dart';

class GetAuthorStoryDetailUseCase {
  final AuthorStoriesRepository repository;

  GetAuthorStoryDetailUseCase(this.repository);

  Future<Either<Failure, AuthorStoryDetailEntity>> call(int id) {
    return repository.getAuthorStoryDetail(id);
  }
}
