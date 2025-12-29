import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_datasource.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments(int comicId) async {
    try {
      final comments = await remoteDataSource.getComments(comicId);
      return Right(comments);
    } catch (e) {
      return Left(ServerFailure("Server Error"));
    }
  }

  @override
  Future<Either<Failure, bool>> postComment(
    int comicId,
    String content, {
    int? parentId,
  }) async {
    try {
      final result = await remoteDataSource.postComment(
        comicId,
        content,
        parentId: parentId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure("Server Error"));
    }
  }

  @override
  Future<Either<Failure, void>> likeComment(int id, int state) async {
    try {
      await remoteDataSource.likeComment(id, state);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
