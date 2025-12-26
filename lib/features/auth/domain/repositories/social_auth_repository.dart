import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/responses/auth_model.dart';

abstract class SocialAuthRepository {
  Future<Either<Failure, AuthModel>> loginSocial({
    required String provider,
    required String token,
  });
}
