import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/base_response.dart';
import '../models/user_profile_model.dart';
import '../models/transaction_model.dart';
import '../models/vip_package_model.dart';
import '../models/update_info_extend_request.dart';
import '../models/user_extend_info_model.dart';

abstract class UserRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<bool> updateProfile({
    required String fullName,
    required String? avatar,
    required String? birthday,
    required int gender,
  });
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<List<TransactionModel>> getTransactionHistory({
    required int offset,
    required int limit,
  });
  Future<List<VipBundleModel>> getVipPackages();
  Future<bool> updateInfoExtend(UpdateInfoExtendRequest request);

  Future<UserExtendInfoModel> getUserExtendInfo();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await dioClient.dio.get('/api/users/me');
      final baseResponse = BaseResponse<UserProfileModel>.fromJson(
        response.data,
        (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
      );

      if (baseResponse.data == null) {
        throw DioException(
          requestOptions: response.requestOptions,
          error: baseResponse.message,
          type: DioExceptionType.badResponse,
        );
      }
      return baseResponse.data!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateProfile({
    required String fullName,
    required String? avatar,
    required String? birthday,
    required int gender,
  }) async {
    try {
      final data = {"full_name": fullName, "gender": gender};
      if (avatar != null) data["avatar"] = avatar;
      if (birthday != null) data["birthday"] = birthday;

      await dioClient.dio.post('/api/users/update-profile', data: data);

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await dioClient.dio.post(
        '/api/users/change-password',
        data: {"old_password": oldPassword, "new_password": newPassword},
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionHistory({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/api/wallet/list-transaction',
        data: {"offset": offset, "limit": limit},
      );
      print("Transaction History Response: ${response.data}");

      final baseResponse = BaseResponse<List<TransactionModel>>.fromJson(
        response.data,
        (json) {
          if (json is List) {
            return json
                .map(
                  (e) => TransactionModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          } else if (json is Map<String, dynamic>) {
            // Handle pagination wrapper
            if (json['data'] is List) {
              return (json['data'] as List)
                  .map(
                    (e) => TransactionModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList();
            }
            if (json['items'] is List) {
              return (json['items'] as List)
                  .map(
                    (e) => TransactionModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList();
            }
            if (json['rows'] is List) {
              return (json['rows'] as List)
                  .map(
                    (e) => TransactionModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList();
            }
          }
          return [];
        },
      );

      if (baseResponse.data == null) {
        return [];
      }
      return baseResponse.data!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<VipBundleModel>> getVipPackages() async {
    try {
      final response = await dioClient.dio.get('/api/vip/get-list');

      final baseResponse = BaseResponse<List<VipBundleModel>>.fromJson(
        response.data,
        (json) {
          if (json is Map<String, dynamic> && json['items'] is List) {
            return (json['items'] as List)
                .map((e) => VipBundleModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );

      if (baseResponse.data == null) {
        return [];
      }
      return baseResponse.data!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateInfoExtend(UpdateInfoExtendRequest request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/user-extend/update-info-extend',
        data: request.toJson(),
      );

      final baseResponse = BaseResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      return baseResponse.code == 'success';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserExtendInfoModel> getUserExtendInfo() async {
    try {
      final response = await dioClient.dio.get(
        '/api/user-extend/get-info-extend',
      );

      final baseResponse = BaseResponse<UserExtendInfoModel>.fromJson(
        response.data,
        (json) => UserExtendInfoModel.fromJson(json as Map<String, dynamic>),
      );

      return baseResponse.data!;
    } catch (e) {
      rethrow;
    }
  }
}
