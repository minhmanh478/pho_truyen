import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/network/api_client.dart';
import 'package:pho_truyen/features/chapter/data/models/chapter_model.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';

abstract class ChapterRemoteDataSource {
  Future<ChapterDetailResponse> getChapterDetail(int id);
  Future<ComicChaptersResponse> getChapters(int storyId);
  Future<dynamic> buyChapter(int id);
}

class ChapterRemoteDataSourceImpl implements ChapterRemoteDataSource {
  final DioClient dioClient = Get.find();

  @override
  Future<ChapterDetailResponse> getChapterDetail(int id) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/chapter/detail',
        data: {'id': id},
      );
      return ChapterDetailResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ComicChaptersResponse> getChapters(int storyId) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/chapter/all',
        data: {'story_id': storyId},
      );
      return ComicChaptersResponse.fromJson(response.data);
    } on DioException catch (e) {
      String message = 'Có lỗi xảy ra';
      if (e.response != null) {
        message = e.response?.data['message'] ?? message;
      }
      return ComicChaptersResponse(code: 'ERROR', message: message, data: []);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  ChapterDetailResponse _handleDioError(DioException error) {
    String message = 'Có lỗi xảy ra';
    if (error.response != null) {
      message = error.response?.data['message'] ?? message;
    }
    return ChapterDetailResponse(code: 'ERROR', message: message);
  }

  @override
  Future<dynamic> buyChapter(int id) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/chapter/buy',
        data: {'id': id},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
