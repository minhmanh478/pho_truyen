import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_story_request.dart';
import '../entities/user_story_entity.dart';
import '../repositories/author_stories_repository.dart';

class GetUserStoriesUseCase {
  final AuthorStoriesRepository repository;

  GetUserStoriesUseCase(this.repository);

  Future<Either<Failure, List<UserStoryEntity>>> call(
    UserStoryRequest request,
  ) {
    return repository.getUserStories(request);
  }
}
