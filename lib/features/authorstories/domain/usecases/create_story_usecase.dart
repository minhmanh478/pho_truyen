import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/create_story_request.dart';
import '../repositories/author_stories_repository.dart';

class CreateStoryUseCase {
  final AuthorStoriesRepository repository;

  CreateStoryUseCase(this.repository);

  Future<Either<Failure, bool>> call(CreateStoryRequest request) {
    return repository.createStory(request);
  }
}
