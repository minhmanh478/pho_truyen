import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_story_entity.dart';
import '../../data/models/create_story_request.dart';
import '../../data/models/user_story_request.dart';
import '../entities/author_story_detail_entity.dart';
import '../entities/author_chapter_entity.dart';
import '../entities/author_chapter_detail_entity.dart';
import '../../data/models/update_chapter_request.dart';

abstract class AuthorStoriesRepository {
  Future<Either<Failure, List<UserStoryEntity>>> getUserStories(
    UserStoryRequest request,
  );

  Future<Either<Failure, bool>> createStory(CreateStoryRequest request);

  Future<Either<Failure, AuthorStoryDetailEntity>> getAuthorStoryDetail(int id);

  Future<Either<Failure, List<AuthorChapterEntity>>> getAuthorChapters(
    int storyId,
  );

  Future<Either<Failure, AuthorChapterDetailResultEntity>>
  getAuthorChapterDetail(int id);

  Future<Either<Failure, bool>> updateChapter(UpdateChapterRequest request);

  Future<Either<Failure, bool>> sendChapterApproved(int id, int status);

  Future<Either<Failure, bool>> finishStory(int id);

  Future<Either<Failure, bool>> sendStoryApproved(int id, int status);
}
