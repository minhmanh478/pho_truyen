import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/comment_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getComments(int comicId);
  Future<Either<Failure, bool>> postComment(
    int comicId,
    String content, {
    int? parentId,
  });
  Future<Either<Failure, void>> likeComment(int id, int state);
}
