// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/token_service.dart';
import 'package:pho_truyen/features/auth/data/models/requests/login_request.dart';
import 'package:pho_truyen/features/auth/data/models/responses/auth_model.dart';
import 'package:pho_truyen/features/auth/data/models/responses/token_model.dart';

abstract class LoginRemoteDataSource {
  Future<AuthModel> login(LoginRequest request);
  Future<TokenModel> refreshToken(String refreshToken);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final DioClient dioClient;

  LoginRemoteDataSourceImpl({required this.dioClient});

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
  Future<TokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await dioClient.dio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final baseResponse = BaseResponse<TokenModel>.fromJson(
        response.data,
        (json) => TokenModel.fromJson(json as Map<String, dynamic>),
      );

      if (baseResponse.data == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      final tokenData = baseResponse.data!;
      if (tokenData.accessToken.isNotEmpty) {
        await TokenService().saveToken(tokenData.accessToken);
        print('Access Token refreshed and saved');
      }
      if (tokenData.refreshToken != null &&
          tokenData.refreshToken!.isNotEmpty) {
        await TokenService().saveRefreshToken(tokenData.refreshToken!);
        print('Refresh Token refreshed and saved');
      }

      return tokenData;
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
