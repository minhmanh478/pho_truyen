// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'token_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api-dev-photruyen.deepviet.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Token Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenService().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final RequestOptions requestOptions = error.requestOptions;
            if (requestOptions.path.contains('/api/auth/refresh')) {
              await TokenService().removeToken();
              return handler.next(error);
            }

            try {
              final refreshToken = await TokenService().getRefreshToken();
              if (refreshToken == null) {
                // Không có refresh token -> Logout
                await TokenService().removeToken();
                return handler.next(error);
              }

              print('Token expired. Refreshing...');

              final refreshDio = Dio(
                BaseOptions(
                  baseUrl: _dio.options.baseUrl,
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                  },
                ),
              );

              final response = await refreshDio.post(
                '/api/auth/refresh',
                data: {'refresh_token': refreshToken},
              );

              if (response.statusCode == 200 && response.data != null) {
                // Parse response
                final data = response.data['data'];
                final newAccessToken = data['access_token'];

                if (newAccessToken != null) {
                  print('Token refreshed successfully');
                  // Lưu token mới
                  await TokenService().saveToken(newAccessToken);

                  // Update header của request cũ
                  requestOptions.headers['Authorization'] = newAccessToken;

                  // Thử lại request cũ với token mới
                  final clonedRequest = await _dio.fetch(requestOptions);
                  return handler.resolve(clonedRequest);
                }
              }
            } catch (e) {
              print('Refresh token failed: $e');
              await TokenService().removeToken();
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Thêm Log để dễ debug (chỉ nên bật ở chế độ Debug)
    // _dio.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    //   ),
    // );
  }

  Dio get dio => _dio;
}
