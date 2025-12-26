// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/base_response.dart';
import '../models/requests/forgot_password_request.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<String> requestForgotPassword(String email);
  Future<String> verifyCode(String transactionId, String otp);
  Future<bool> updatePassword(String transactionId, String password);
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  final DioClient dioClient;

  ForgotPasswordRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<String> requestForgotPassword(String email) async {
    try {
      final request = ForgotPasswordRequest(email: email);
      final response = await dioClient.dio.post(
        '/api/auth/forgot_password/request',
        data: request.toJson(),
      );
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
      print(" Verify OTP Request: ${request.toJson()}");

      final response = await dioClient.dio.post(
        '/api/auth/forgot_password/verify_otp',
        data: request.toJson(),
      );

      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
      final newTransactionId = baseResponse.data?['transaction_id'];
      // Nếu API trả về transaction_id mới thì dùng, không thì dùng cái cũ
      if (newTransactionId != null) {
        print("OTP Verified. New Transaction ID: $newTransactionId");
        return newTransactionId;
      } else {
        print("OTP Verified. Keeping old Transaction ID: $transactionId");
        return transactionId;
      }
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
