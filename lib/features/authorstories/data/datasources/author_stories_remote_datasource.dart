// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/base_response.dart';
import '../models/create_story_request.dart';
import '../models/user_story_model.dart';
import '../models/user_story_request.dart';
import '../models/author_story_detail_model.dart';
import '../models/author_chapter_model.dart';
import '../models/author_chapter_detail_model.dart';
import '../models/update_chapter_request.dart';

abstract class AuthorStoriesRemoteDataSource {
  Future<List<UserStoryModel>> getUserStories(UserStoryRequest request);

  Future<bool> createStory(CreateStoryRequest request);

  Future<AuthorStoryDetailModel> getAuthorStoryDetail(int id);

  Future<List<AuthorChapterModel>> getAuthorChapters(int storyId);

  Future<AuthorChapterDetailResultModel> getAuthorChapterDetail(int id);

  Future<bool> updateChapter(UpdateChapterRequest request);

  Future<bool> sendChapterApproved(int id, int status);

  Future<bool> finishStory(int id);

  Future<bool> sendStoryApproved(int id, int status);
}

class AuthorStoriesRemoteDataSourceImpl
    implements AuthorStoriesRemoteDataSource {
  final DioClient dioClient;

  AuthorStoriesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<bool> createStory(CreateStoryRequest request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/create-update',
        data: request.toJson(),
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      final baseResponse = BaseResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (baseResponse.code != '200' &&
          baseResponse.code != 'success' &&
          baseResponse.code != 'SUCCESS') {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/story/create-update'),
        error: "Lỗi không xác định: $e",
      );
    }
  }

  @override
  Future<List<UserStoryModel>> getUserStories(UserStoryRequest request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/user-story',
        data: request.toJson(),
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (baseResponse.data == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      final items = baseResponse.data!['items'] as List? ?? [];
      return items.map((e) => UserStoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/story/user-story'),
        error: "Lỗi không xác định: $e",
      );
    }
  }

  @override
  Future<AuthorStoryDetailModel> getAuthorStoryDetail(int id) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/author-story-detail',
        data: {'id': id},
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (baseResponse.data == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      return AuthorStoryDetailModel.fromJson(baseResponse.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/story/author-story-detail'),
        error: "Lỗi không xác định: $e",
      );
    }
  }

  @override
  Future<AuthorChapterDetailResultModel> getAuthorChapterDetail(int id) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/chapter/author-detail',
        data: {'id': id},
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (baseResponse.data == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      return AuthorChapterDetailResultModel.fromJson(baseResponse.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(
          path: '/api/story/chapter/author-detail',
        ),
        error: "Lỗi không xác định: $e",
      );
    }
  }

  @override
  Future<bool> updateChapter(UpdateChapterRequest request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/chapter/create-update',
        data: request.toJson(),
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      final baseResponse = BaseResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (baseResponse.code != '200' &&
          baseResponse.code != 'success' &&
          baseResponse.code != 'SUCCESS') {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(
          path: '/api/story/chapter/create-update',
        ),
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

  @override
  Future<List<AuthorChapterModel>> getAuthorChapters(int storyId) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/chapter/author-all',
        data: {'story_id': storyId},
      );

      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      // Parse as dynamic to handle both List and Map (wrapped list)
      final baseResponse = BaseResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (baseResponse.data == null) {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      List<dynamic> listData = [];
      if (baseResponse.data is List) {
        listData = baseResponse.data;
      } else if (baseResponse.data is Map) {
        final mapData = baseResponse.data as Map;
        if (mapData.containsKey('items') && mapData['items'] is List) {
          listData = mapData['items'];
        } else if (mapData.containsKey('data') && mapData['data'] is List) {
          listData = mapData['data'];
        } else {
          // Try to find any list value? or just default empty
          // For now assume 'items' is the standard
          listData = mapData['items'] as List? ?? [];
        }
      }

      return listData
          .map((e) => AuthorChapterModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/story/chapter/author-all'),
        error: "Lỗi không xác định: $e",
      );
    }
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
        default:
          errorMessage = e.message ?? "Lỗi không xác định.";
          break;
      }
    }

    return DioException(
      requestOptions: e.requestOptions,
      response: e.response,
      error: errorMessage,
      type: e.type,
    );
  }

  @override
  Future<bool> finishStory(int id) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/change-story-full',
        data: {'id': id},
      );

      if (response.statusCode == 200) {
        final baseResponse = BaseResponse<dynamic>.fromJson(
          response.data,
          (json) => json,
        );

        if (baseResponse.code != '200' &&
            baseResponse.code != 'success' &&
            baseResponse.code != 'SUCCESS') {
          throw _createCustomException(
            response.requestOptions,
            baseResponse.message,
          );
        }
        return true;
      } else {
        throw _createCustomException(response.requestOptions, 'Lỗi kết nối');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/story/change-story-full'),
        error: "Lỗi không xác định: $e",
      );
    }
  }

  @override
  Future<bool> sendChapterApproved(int id, int status) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/chapter/change-send-approved',
        data: {'id': id, 'is_send_approved': status},
      );
      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      final baseResponse = BaseResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (baseResponse.code != '200' &&
          baseResponse.code != 'success' &&
          baseResponse.code != 'SUCCESS') {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(
          path: '/api/story/chapter/change-send-approved',
        ),
        error: "Lỗi không xác định: $e",
      );
    }
  }

  @override
  Future<bool> sendStoryApproved(int id, int status) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/change-send-approved',
        data: {'id': id, 'is_send_approved': status},
      );
      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw _createCustomException(
          response.requestOptions,
          'Phản hồi từ máy chủ không hợp lệ.',
        );
      }

      final baseResponse = BaseResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      if (baseResponse.code != '200' &&
          baseResponse.code != 'success' &&
          baseResponse.code != 'SUCCESS') {
        throw _createCustomException(
          response.requestOptions,
          baseResponse.message,
        );
      }

      return true;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/story/change-send-approved'),
        error: "Lỗi không xác định: $e",
      );
    }
  }
}
