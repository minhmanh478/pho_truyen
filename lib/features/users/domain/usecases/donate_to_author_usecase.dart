import 'package:dartz/dartz.dart';
import 'package:pho_truyen/core/error/failures.dart';
import '../repositories/user_repository.dart';

class DonateToAuthorUseCase {
  final UserRepository repository;

  DonateToAuthorUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required int authorId,
    required int amount,
  }) async {
    return await repository.donateToAuthor(authorId: authorId, amount: amount);
  }
}
