import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/author_chapter_detail_entity.dart';
import '../repositories/author_stories_repository.dart';

class GetAuthorChapterDetailUseCase
    implements UseCase<AuthorChapterDetailResultEntity, int> {
  final AuthorStoriesRepository repository;

  GetAuthorChapterDetailUseCase(this.repository);

  @override
  Future<Either<Failure, AuthorChapterDetailResultEntity>> call(int id) async {
    return await repository.getAuthorChapterDetail(id);
  }
}
