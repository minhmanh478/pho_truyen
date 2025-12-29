import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/repositories/comment_repository.dart';

class PostCommentUseCase implements UseCase<bool, PostCommentParams> {
  final CommentRepository repository;

  PostCommentUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(PostCommentParams params) async {
    return await repository.postComment(
      params.comicId,
      params.content,
      parentId: params.parentId,
    );
  }
}

class PostCommentParams extends Equatable {
  final int comicId;
  final String content;
  final int? parentId;

  const PostCommentParams({
    required this.comicId,
    required this.content,
    this.parentId,
  });

  @override
  List<Object?> get props => [comicId, content, parentId];
}
