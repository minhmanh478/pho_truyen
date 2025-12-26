import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_repository.dart';

class UpdateProfileUseCase {
  final UserRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String fullName,
    required String? avatar,
    required String? birthday,
    required int gender,
  }) async {
    return await repository.updateProfile(
      fullName: fullName,
      avatar: avatar,
      birthday: birthday,
      gender: gender,
    );
  }
}
