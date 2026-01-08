// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/base_response.dart';
import '../models/uploaded_response_model.dart';

abstract class CommonRemoteDataSource {
  Future<UploadedResponseModel> uploadImage(File file);
}

class CommonRemoteDataSourceImpl implements CommonRemoteDataSource {
  final DioClient dioClient;

  CommonRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UploadedResponseModel> uploadImage(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dioClient.dio.post(
        '/files/upload-image',
        data: formData,
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      final baseResponse = BaseResponse<UploadedResponseModel>.fromJson(
        response.data,
        (json) => UploadedResponseModel.fromJson(json as Map<String, dynamic>),
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
        requestOptions: RequestOptions(path: '/files/upload-image'),
        error: "Lỗi không xác định: $e",
      );
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
