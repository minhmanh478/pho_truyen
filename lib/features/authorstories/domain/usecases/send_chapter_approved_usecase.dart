import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/author_stories_repository.dart';

class SendChapterApprovedParams {
  final int id;
  final int status;

  SendChapterApprovedParams({required this.id, required this.status});
}

class SendChapterApprovedUseCase
    implements UseCase<bool, SendChapterApprovedParams> {
  final AuthorStoriesRepository repository;

  SendChapterApprovedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendChapterApprovedParams params) async {
    return await repository.sendChapterApproved(params.id, params.status);
  }
}
