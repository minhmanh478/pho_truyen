import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class RequestForgotPasswordUseCase {
  final AuthRepository repository;

  RequestForgotPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call(String email) async {
    return await repository.requestForgotPassword(email);
  }
}
