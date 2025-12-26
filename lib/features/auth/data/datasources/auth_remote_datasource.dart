// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/token_service.dart';
import '../../../../core/network/base_response.dart';
import '../models/responses/auth_model.dart';

import '../models/requests/login_request.dart';
import '../models/requests/register_request.dart';
import '../models/requests/forgot_password_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(LoginRequest request);
  Future<AuthModel> register(RegisterRequest request);
  Future<String> requestForgotPassword(String email);
  Future<String> verifyCode(String transactionId, String otp);
  Future<bool> updatePassword(String transactionId, String password);
  Future<AuthModel> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthModel> login(LoginRequest request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );

      final baseResponse = BaseResponse<AuthModel>.fromJson(
        response.data,
        (json) => AuthModel.fromJson(json as Map<String, dynamic>),
      );

      // Kiểm tra data
      if (baseResponse.data == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      final authData = baseResponse.data!;
      if (authData.token.isNotEmpty) {
        await TokenService().saveToken(authData.token);
        print('Access Token saved');
      }
      if (authData.refreshToken != null && authData.refreshToken!.isNotEmpty) {
        await TokenService().saveRefreshToken(authData.refreshToken!);
        print('Refresh Token saved');
      }

      return authData;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/auth/login'),
        error: "Lỗi không xác định: $e",
      );
    }
  }

  @override
  Future<AuthModel> register(RegisterRequest request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );
      final baseResponse = BaseResponse<AuthModel>.fromJson(
        response.data,
        (json) => AuthModel.fromJson(json as Map<String, dynamic>),
      );

      if (baseResponse.data == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      return baseResponse.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/auth/register'),
        error: "Lỗi không xác định: $e",
      );
    }
  }

  @override
  Future<String> requestForgotPassword(String email) async {
    try {
      final request = ForgotPasswordRequest(email: email);
      final response = await dioClient.dio.post(
        '/api/auth/forgot_password/request',
        data: request.toJson(),
      );

      // Xử lý response map
      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      final transactionId = baseResponse.data?['transaction_id'];
      if (transactionId == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message.isEmpty
              ? "Không tìm thấy transaction_id"
              : baseResponse.message,
        );
      }
      return transactionId;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> verifyCode(String transactionId, String otp) async {
    try {
      final request = VerifyOtpRequest(transactionId: transactionId, otp: otp);
      print("📤 Verify OTP Request: ${request.toJson()}");

      final response = await dioClient.dio.post(
        '/api/auth/forgot_password/verify_otp',
        data: request.toJson(),
      );

      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      // Logic: Nếu message thành công hoặc có transaction_id mới trả về thì OK
      final newTransactionId = baseResponse.data?['transaction_id'];

      // Kiểm tra chặt chẽ: Phải có transaction_id để dùng cho bước đổi pass
      if (newTransactionId == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message.isEmpty
              ? "Xác thực thất bại"
              : baseResponse.message,
        );
      }

      print("OTP Verified. New Transaction ID: $newTransactionId");
      return newTransactionId;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<bool> updatePassword(String transactionId, String password) async {
    try {
      final request = UpdatePasswordRequest(
        transactionId: transactionId,
        newPassword: password,
      );

      final response = await dioClient.dio.post(
        '/api/auth/forgot_password/update_password',
        data: request.toJson(),
      );

      // Kiểm tra message từ server nếu cần
      final baseResponse = BaseResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      print("Update Password Message: ${baseResponse.message}");
      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    try {
      final response = await dioClient.dio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final baseResponse = BaseResponse<AuthModel>.fromJson(
        response.data,
        (json) => AuthModel.fromJson(json as Map<String, dynamic>),
      );

      if (baseResponse.data == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      final authData = baseResponse.data!;
      // Lưu token mới ngay tại đây
      if (authData.token.isNotEmpty) {
        await TokenService().saveToken(authData.token);
        print('Access Token refreshed and saved');
      }
      // API refresh thường chỉ trả về access_token, nhưng nếu có refresh_token mới thì lưu luôn
      if (authData.refreshToken != null && authData.refreshToken!.isNotEmpty) {
        await TokenService().saveRefreshToken(authData.refreshToken!);
        print('Refresh Token refreshed and saved');
      }

      return authData;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Helpers

  DioException _createCustomException(RequestOptions options, String message) {
    return DioException(
      requestOptions: options,
      error: message,
      type: DioExceptionType.badResponse,
    );
  }

  DioException _handleDioError(DioException e) {
    String errorMessage = 'Có lỗi xảy ra, vui lòng thử lại.';

    if (e.response != null && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        try {
          // Cố gắng parse theo cấu trúc BaseResponse
          final baseResponse = BaseResponse<dynamic>.fromJson(
            data,
            (json) => json,
          );
          errorMessage = baseResponse.message;
        } catch (_) {
          errorMessage = data['message'] ?? data['error'] ?? errorMessage;
        }
      } else if (data is String) {
        if (data.contains('<!DOCTYPE html>') || data.contains('<html')) {
          errorMessage = 'Lỗi máy chủ (HTML Response). Vui lòng liên hệ admin.';
        } else {
          errorMessage = data;
        }
      }
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = "Hết thời gian kết nối. Vui lòng kiểm tra mạng.";
          break;
        case DioExceptionType.connectionError:
          errorMessage = "Không có kết nối Internet.";
          break;
        case DioExceptionType.cancel:
          errorMessage = "Yêu cầu đã bị hủy.";
          break;
        case DioExceptionType.unknown:
          if (e.error.toString().contains("SocketException")) {
            errorMessage = "Không thể kết nối đến máy chủ. Kiểm tra mạng/VPN.";
          } else if (e.error.toString().contains("HandshakeException")) {
            errorMessage = "Lỗi chứng chỉ bảo mật (SSL).";
          } else {
            errorMessage = "Lỗi hệ thống: ${e.error}";
          }
          break;
        default:
          errorMessage = e.message ?? "Lỗi không xác định.";
          break;
      }
    }

    print("LOG API ERROR: $errorMessage");

    return DioException(
      requestOptions: e.requestOptions,
      response: e.response,
      error: errorMessage,
      type: e.type,
    );
  }
}
