import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/comment_repository.dart';

class LikeCommentParams {
  final int id;
  final int state;

  LikeCommentParams({required this.id, required this.state});
}

class LikeCommentUseCase implements UseCase<void, LikeCommentParams> {
  final CommentRepository repository;

  LikeCommentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LikeCommentParams params) {
    return repository.likeComment(params.id, params.state);
  }
}
