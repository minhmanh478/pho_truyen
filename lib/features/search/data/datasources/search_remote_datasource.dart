import '../../../../core/network/api_client.dart';
import '../../../../core/network/base_response.dart';
import '../models/search_story_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchStoryModel>> searchStories({
    required String query,
    int offset = 0,
    int limit = 20,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<SearchStoryModel>> searchStories({
    required String query,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/api/story/all',
        data: {
          "search": query,
          "order": "chapter_count",
          "category_id": "",
          "tag": "",
          "state": "",
          "chapter_min": null,
          "chapter_max": null,
          "time_update": null,
          "offset": offset,
          "limit": limit,
          "sort": "desc",
          "code": "STORY_FULL",
        },
      );

      final baseResponse = BaseResponse<dynamic>.fromJson(
        response.data,
        (json) => json,
      );

      List<dynamic> listData = [];
      if (baseResponse.data is List) {
        listData = baseResponse.data as List;
      } else if (baseResponse.data is Map) {
        final map = baseResponse.data as Map;
        if (map.containsKey('data') && map['data'] is List) {
          listData = map['data'];
        } else if (map.containsKey('items') && map['items'] is List) {
          listData = map['items'];
        }
      }

      return listData
          .map((e) => SearchStoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
