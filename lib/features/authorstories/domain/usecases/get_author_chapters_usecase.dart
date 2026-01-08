import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/author_chapter_entity.dart';
import '../repositories/author_stories_repository.dart';

class GetAuthorChaptersUseCase
    implements UseCase<List<AuthorChapterEntity>, int> {
  final AuthorStoriesRepository repository;

  GetAuthorChaptersUseCase(this.repository);

  @override
  Future<Either<Failure, List<AuthorChapterEntity>>> call(int storyId) async {
    return await repository.getAuthorChapters(storyId);
  }
}
