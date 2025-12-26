import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<Either<Failure, bool>> call(
    String transactionId,
    String password,
  ) async {
    return await repository.updatePassword(transactionId, password);
  }
}
