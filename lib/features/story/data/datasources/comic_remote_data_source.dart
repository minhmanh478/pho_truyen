import 'package:pho_truyen/core/network/api_client.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';

import 'package:pho_truyen/features/story/data/models/filter_settings_model.dart';
import 'package:pho_truyen/features/story/data/models/story_tag_model.dart';

abstract class ComicRemoteDataSource {
  Future<ComicDetailModel> getComicDetail(int id);
  Future<List<StoryTagModel>> getStoryTags();
  Future<FilterSettingsModel> getFilterSettings();
  Future<dynamic> getStories({
    String? search,
    String? order,
    String? categoryId,
    String? tag,
    String? state,
    String? chapterMin,
    String? chapterMax,
    String? timeUpdate,
    int offset = 0,
    int limit = 20,
    String? sort,
    String? code,
  });
  Future<dynamic> getFavoriteStories(
    int userId, {
    int offset = 0,
    int limit = 20,
  });
  Future<dynamic> getViewedStories(
    int userId, {
    int offset = 0,
    int limit = 20,
  });
  Future<dynamic> getReadHistory(int userId, {int offset = 0, int limit = 20});
  Future<dynamic> toggleFavoriteStory(int storyId, int state);
}

class ComicRemoteDataSourceImpl implements ComicRemoteDataSource {
  final DioClient dioClient = DioClient();

  @override
  Future<ComicDetailModel> getComicDetail(int id) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/detail',
        data: {'id': id},
      );
      if (response.data['code'] == 'success' && response.data['data'] != null) {
        return ComicDetailModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Unknown error');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<StoryTagModel>> getStoryTags() async {
    try {
      final response = await dioClient.dio.get('/api/story/tags');
      dynamic responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          responseData = responseData['data'];
        }
      }

      if (responseData is List) {
        return responseData.map((e) => StoryTagModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching tags: $e');
      return [];
    }
  }

  @override
  Future<FilterSettingsModel> getFilterSettings() async {
    try {
      final response = await dioClient.dio.get('/api/story/filter-settings');
      return FilterSettingsModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getStories({
    String? search,
    String? order,
    String? categoryId,
    String? tag,
    String? state,
    String? chapterMin,
    String? chapterMax,
    String? timeUpdate,
    int offset = 0,
    int limit = 20,
    String? sort,
    String? code,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/all',
        data: {
          'search': search ?? '',
          'order': order ?? 'chapter_count',
          'category_id': categoryId ?? '',
          'tag': tag ?? '',
          'state': state ?? '',
          'chapter_min': chapterMin,
          'chapter_max': chapterMax,
          'time_update': timeUpdate,
          'offset': offset,
          'limit': limit,
          'sort': sort ?? 'desc',
          'code': code ?? 'STORY_FULL',
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getFavoriteStories(
    int userId, {
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/user-favorite',
        data: {
          'user_id': userId,
          'search': '',
          'offset': offset,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getViewedStories(
    int userId, {
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/user-view',
        data: {
          'user_id': userId,
          'search': '',
          'offset': offset,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getReadHistory(
    int userId, {
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/user-story-read-chapter',
        data: {
          'user_id': userId,
          'search': '',
          'offset': offset,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> toggleFavoriteStory(int storyId, int state) async {
    try {
      print(
        'ComicRemoteDataSource: Toggling favorite for story $storyId with state $state',
      );
      final response = await dioClient.dio.post(
        '/api/story/favorite',
        data: {'id': storyId, 'state': state},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
