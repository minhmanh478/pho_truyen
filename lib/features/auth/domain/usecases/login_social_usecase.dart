import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/responses/auth_model.dart';
import '../repositories/social_auth_repository.dart';

class LoginSocialUseCase {
  final SocialAuthRepository repository;

  LoginSocialUseCase({required this.repository});

  Future<Either<Failure, AuthModel>> call({
    required String provider,
    required String token,
  }) async {
    return await repository.loginSocial(provider: provider, token: token);
  }
}
