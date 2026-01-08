import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../repositories/author_stories_repository.dart';

class FinishStoryUseCase implements UseCase<bool, int> {
  final AuthorStoriesRepository repository;

  FinishStoryUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(int storyId) async {
    return await repository.finishStory(storyId);
  }
}
