import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/search_story_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchStoryEntity>>> searchStories({
    required String query,
    int offset = 0,
    int limit = 20,
  });
}
