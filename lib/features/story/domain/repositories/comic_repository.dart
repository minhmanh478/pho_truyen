import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';

import 'package:pho_truyen/features/story/data/models/filter_settings_model.dart';
import 'package:pho_truyen/features/story/data/models/story_tag_model.dart';

abstract class ComicRepository {
  Future<ComicDetailModel> getComicDetail(int id);
  Future<List<StoryTagModel>> getStoryTags();
  Future<FilterSettingsModel> getFilterSettings();
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
  });
  Future<List<StoryModel>> getFavoriteStories(
    int userId, {
    int offset = 0,
    int limit = 20,
  });
  Future<List<StoryModel>> getViewedStories(
    int userId, {
    int offset = 0,
    int limit = 20,
  });
  Future<List<StoryModel>> getReadHistory(
    int userId, {
    int offset = 0,
    int limit = 20,
  });
  Future<bool> toggleFavoriteStory(int storyId, int state);
}
