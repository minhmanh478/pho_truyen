import 'package:pho_truyen/features/chapter/data/datasources/chapter_remote_data_source.dart';
import 'package:pho_truyen/features/chapter/data/models/chapter_model.dart';
import 'package:pho_truyen/features/chapter/domain/repositories/chapter_repository.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';
import 'package:pho_truyen/core/network/base_response.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterRemoteDataSource remoteDataSource;

  ChapterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ChapterDetailResponse> getChapterDetail(int id) async {
    return await remoteDataSource.getChapterDetail(id);
  }

  @override
  Future<ComicChaptersResponse> getChapters(int storyId) async {
    return await remoteDataSource.getChapters(storyId);
  }

  @override
  Future<BaseResponse> buyChapter(int id) async {
    final response = await remoteDataSource.buyChapter(id);
    return BaseResponse.fromJson(response, (json) => null);
  }
}
