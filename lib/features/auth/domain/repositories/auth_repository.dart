import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/requests/login_request.dart';
import '../../data/models/requests/register_request.dart';
import '../entities/auth_entity.dart';
import '../entities/token_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(LoginRequest request);
  Future<Either<Failure, AuthEntity>> register(RegisterRequest request);
  Future<Either<Failure, String>> requestForgotPassword(String email);
  Future<Either<Failure, String>> verifyCode(String transactionId, String otp);
  Future<Either<Failure, bool>> updatePassword(
    String transactionId,
    String password,
  );
  Future<Either<Failure, TokenEntity>> refreshToken(String refreshToken);
}
