import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile_entity.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/vip_package_model.dart';
import '../../data/models/update_info_extend_request.dart';
import '../../data/models/user_extend_info_model.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
  Future<Either<Failure, bool>> updateProfile({
    required String fullName,
    required String? avatar,
    required String? birthday,
    required int gender,
  });
  Future<Either<Failure, bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<Either<Failure, List<TransactionModel>>> getTransactionHistory({
    required int offset,
    required int limit,
  });
  Future<Either<Failure, List<VipBundleModel>>> getVipPackages();
  Future<Either<Failure, bool>> updateInfoExtend(
    UpdateInfoExtendRequest request,
  );
  Future<Either<Failure, UserExtendInfoModel>> getUserExtendInfo();
}
