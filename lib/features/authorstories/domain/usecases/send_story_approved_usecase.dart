import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/author_stories_repository.dart';

class SendStoryApprovedParams extends Equatable {
  final int id;
  final int status;

  const SendStoryApprovedParams({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

class SendStoryApprovedUseCase
    implements UseCase<bool, SendStoryApprovedParams> {
  final AuthorStoriesRepository repository;

  SendStoryApprovedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendStoryApprovedParams params) async {
    return await repository.sendStoryApproved(params.id, params.status);
  }
}
