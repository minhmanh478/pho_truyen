import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/requests/register_request.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(RegisterRequest request) async {
    return await repository.register(request);
  }
}
