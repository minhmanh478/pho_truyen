import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import 'package:pho_truyen/features/users/domain/entities/user_profile_entity.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/vip_package_model.dart';
import '../../data/models/update_info_extend_request.dart';
import '../../data/models/user_extend_info_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    try {
      final result = await remoteDataSource.getUserProfile();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfile({
    required String fullName,
    required String? avatar,
    required String? birthday,
    required int gender,
  }) async {
    try {
      final result = await remoteDataSource.updateProfile(
        fullName: fullName,
        avatar: avatar,
        birthday: birthday,
        gender: gender,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final result = await remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // lịch sử giao dịch
  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactionHistory({
    required int offset,
    required int limit,
  }) async {
    try {
      final result = await remoteDataSource.getTransactionHistory(
        offset: offset,
        limit: limit,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VipBundleModel>>> getVipPackages() async {
    try {
      final result = await remoteDataSource.getVipPackages();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateInfoExtend(
    UpdateInfoExtendRequest request,
  ) async {
    try {
      final result = await remoteDataSource.updateInfoExtend(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserExtendInfoModel>> getUserExtendInfo() async {
    try {
      final result = await remoteDataSource.getUserExtendInfo();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> buyVip(int timeId) async {
    try {
      final result = await remoteDataSource.buyVip(timeId);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Something went wrong'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
