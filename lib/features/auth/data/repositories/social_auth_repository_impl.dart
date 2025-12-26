import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/social_auth_repository.dart';
import '../datasources/social_auth_remote_datasource.dart';
import '../models/requests/social_login_request.dart';
import '../models/responses/auth_model.dart';

class SocialAuthRepositoryImpl implements SocialAuthRepository {
  final SocialAuthRemoteDataSource remoteDataSource;

  SocialAuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthModel>> loginSocial({
    required String provider,
    required String token,
  }) async {
    try {
      final request = SocialLoginRequest(provider: provider, token: token);
      final result = await remoteDataSource.loginSocial(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
