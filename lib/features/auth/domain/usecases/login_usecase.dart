import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/requests/login_request.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(LoginRequest request) async {
    return await repository.login(request);
  }
}
