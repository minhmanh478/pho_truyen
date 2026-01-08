import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/update_chapter_request.dart';
import '../repositories/author_stories_repository.dart';

class UpdateChapterUseCase implements UseCase<bool, UpdateChapterRequest> {
  final AuthorStoriesRepository repository;

  UpdateChapterUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateChapterRequest params) async {
    return await repository.updateChapter(params);
  }
}
