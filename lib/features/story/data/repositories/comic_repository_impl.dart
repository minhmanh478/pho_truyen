import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/story/data/datasources/comic_remote_data_source.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';
import 'package:pho_truyen/features/story/data/models/filter_settings_model.dart';
import 'package:pho_truyen/features/story/data/models/story_tag_model.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class ComicRepositoryImpl implements ComicRepository {
  final ComicRemoteDataSource _remoteDataSource;

  ComicRepositoryImpl({required ComicRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<ComicDetailModel> getComicDetail(int id) async {
    return await _remoteDataSource.getComicDetail(id);
  }

  @override
  Future<List<StoryTagModel>> getStoryTags() async {
    return await _remoteDataSource.getStoryTags();
  }

  @override
  Future<FilterSettingsModel> getFilterSettings() async {
    return await _remoteDataSource.getFilterSettings();
  }

  @override
  Future<List<StoryModel>> getStories({
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
    final response = await _remoteDataSource.getStories(
      search: search,
      order: order,
      categoryId: categoryId,
      tag: tag,
      state: state,
      chapterMin: chapterMin,
      chapterMax: chapterMax,
      timeUpdate: timeUpdate,
      offset: offset,
      limit: limit,
      sort: sort,
      code: code,
    );
    if (response['code'] == 'success') {
      final items = response['data']['items'] as List;
      return items.map((e) => StoryModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<StoryModel>> getFavoriteStories(
    int userId, {
    int offset = 0,
    int limit = 20,
  }) async {
    final response = await _remoteDataSource.getFavoriteStories(
      userId,
      offset: offset,
      limit: limit,
    );
    if (response['code'] == 'success') {
      final items = response['data']['items'] as List;
      return items.map((e) => StoryModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<StoryModel>> getViewedStories(
    int userId, {
    int offset = 0,
    int limit = 20,
  }) async {
    final response = await _remoteDataSource.getViewedStories(
      userId,
      offset: offset,
      limit: limit,
    );
    if (response['code'] == 'success') {
      final items = response['data']['items'] as List;
      return items.map((e) => StoryModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<StoryModel>> getReadHistory(
    int userId, {
    int offset = 0,
    int limit = 20,
  }) async {
    final response = await _remoteDataSource.getReadHistory(
      userId,
      offset: offset,
      limit: limit,
    );
    if (response['code'] == 'success') {
      final items = response['data']['items'] as List;
      return items.map((e) => StoryModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<bool> toggleFavoriteStory(int storyId, int state) async {
    final response = await _remoteDataSource.toggleFavoriteStory(
      storyId,
      state,
    );
    return response['code'] == 'success';
  }
}
