import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/token_entity.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, TokenEntity>> call(String refreshToken) async {
    return await repository.refreshToken(refreshToken);
  }
}
