import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecase/usecase.dart';
import '../repositories/user_repository.dart';

class BuyVipUseCase implements UseCase<bool, int> {
  final UserRepository repository;

  BuyVipUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(int timeId) async {
    return await repository.buyVip(timeId);
  }
}
