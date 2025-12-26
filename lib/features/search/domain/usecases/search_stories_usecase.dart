import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/search_story_entity.dart';
import '../repositories/search_repository.dart';

class SearchStoriesUseCase {
  final SearchRepository repository;

  SearchStoriesUseCase(this.repository);

  Future<Either<Failure, List<SearchStoryEntity>>> call({
    required String query,
    int offset = 0,
    int limit = 20,
  }) async {
    return await repository.searchStories(
      query: query,
      offset: offset,
      limit: limit,
    );
  }
}
