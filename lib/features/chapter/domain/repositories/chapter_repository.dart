import 'package:pho_truyen/features/chapter/data/models/chapter_model.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';
import 'package:pho_truyen/core/network/base_response.dart';

abstract class ChapterRepository {
  Future<ChapterDetailResponse> getChapterDetail(int id);
  Future<ComicChaptersResponse> getChapters(int storyId);
  Future<BaseResponse> buyChapter(int id);
}
