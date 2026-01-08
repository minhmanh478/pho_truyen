import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/author_stories_remote_datasource.dart';
import '../../data/models/create_story_request.dart';
import '../../data/models/user_story_request.dart';
import '../../domain/entities/user_story_entity.dart';
import '../../domain/entities/author_story_detail_entity.dart';
import '../../domain/entities/author_chapter_entity.dart';
import '../../domain/entities/author_chapter_detail_entity.dart';
import '../../domain/repositories/author_stories_repository.dart';
import '../../data/models/update_chapter_request.dart';

class AuthorStoriesRepositoryImpl implements AuthorStoriesRepository {
  final AuthorStoriesRemoteDataSource remoteDataSource;

  AuthorStoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> createStory(CreateStoryRequest request) async {
    try {
      final result = await remoteDataSource.createStory(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserStoryEntity>>> getUserStories(
    UserStoryRequest request,
  ) async {
    try {
      final result = await remoteDataSource.getUserStories(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthorStoryDetailEntity>> getAuthorStoryDetail(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.getAuthorStoryDetail(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AuthorChapterEntity>>> getAuthorChapters(
    int storyId,
  ) async {
    try {
      final result = await remoteDataSource.getAuthorChapters(storyId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthorChapterDetailResultEntity>>
  getAuthorChapterDetail(int id) async {
    try {
      final result = await remoteDataSource.getAuthorChapterDetail(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateChapter(
    UpdateChapterRequest request,
  ) async {
    try {
      final result = await remoteDataSource.updateChapter(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> finishStory(int id) async {
    try {
      final result = await remoteDataSource.finishStory(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendChapterApproved(int id, int status) async {
    try {
      final result = await remoteDataSource.sendChapterApproved(id, status);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendStoryApproved(int id, int status) async {
    try {
      final result = await remoteDataSource.sendStoryApproved(id, status);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
