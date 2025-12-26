import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import 'package:pho_truyen/features/auth/domain/entities/auth_entity.dart';
import 'package:pho_truyen/features/auth/domain/entities/token_entity.dart';
import 'package:pho_truyen/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/login_remote_datasource.dart';
import '../datasources/register_remote_datasource.dart';
import '../datasources/forgot_password_remote_datasource.dart';
import '../models/requests/login_request.dart';
import '../models/requests/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  final RegisterRemoteDataSource registerRemoteDataSource;
  final ForgotPasswordRemoteDataSource forgotPasswordRemoteDataSource;

  AuthRepositoryImpl({
    required this.loginRemoteDataSource,
    required this.registerRemoteDataSource,
    required this.forgotPasswordRemoteDataSource,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(LoginRequest request) async {
    try {
      final result = await loginRemoteDataSource.login(request);
      return Right(result);
    } on DioException catch (e) {
      final errorMessage = e.error?.toString() ?? e.message ?? 'Unknown error';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register(RegisterRequest request) async {
    try {
      final result = await registerRemoteDataSource.register(request);
      return Right(result);
    } on DioException catch (e) {
      final errorMessage = e.error?.toString() ?? e.message ?? 'Unknown error';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> requestForgotPassword(String email) async {
    try {
      final result = await forgotPasswordRemoteDataSource.requestForgotPassword(
        email,
      );
      return Right(result);
    } on DioException catch (e) {
      final errorMessage = e.error?.toString() ?? e.message ?? 'Unknown error';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyCode(
    String transactionId,
    String otp,
  ) async {
    try {
      final result = await forgotPasswordRemoteDataSource.verifyCode(
        transactionId,
        otp,
      );
      return Right(result);
    } on DioException catch (e) {
      final errorMessage = e.error?.toString() ?? e.message ?? 'Unknown error';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePassword(
    String transactionId,
    String password,
  ) async {
    try {
      final result = await forgotPasswordRemoteDataSource.updatePassword(
        transactionId,
        password,
      );
      return Right(result);
    } on DioException catch (e) {
      final errorMessage = e.error?.toString() ?? e.message ?? 'Unknown error';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> refreshToken(String refreshToken) async {
    try {
      final result = await loginRemoteDataSource.refreshToken(refreshToken);
      return Right(result);
    } on DioException catch (e) {
      final errorMessage = e.error?.toString() ?? e.message ?? 'Unknown error';
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
