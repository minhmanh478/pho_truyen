import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetCommentsUseCase implements UseCase<List<CommentEntity>, int> {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CommentEntity>>> call(int params) async {
    return await repository.getComments(params);
  }
}
