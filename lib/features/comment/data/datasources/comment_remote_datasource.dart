import '../models/comment_model.dart';
import '../../../../core/network/api_client.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments(int comicId);
  Future<bool> postComment(int comicId, String content, {int? parentId});
  Future<void> likeComment(int id, int state);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final DioClient dioClient;

  CommentRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CommentModel>> getComments(int comicId) async {
    try {
      final response = await dioClient.dio.post(
        '/api/comment/list',
        data: {
          "object_id": comicId,
          "object_type": 1,
          "last_id": 0, // TODO: trang
          "limit": 20,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['code'] == 'success') {
        final List<dynamic> items = response.data['data']['items'];
        return items.map((json) => CommentModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load comments');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> likeComment(int id, int state) async {
    try {
      final response = await dioClient.dio.post(
        '/api/comment/like',
        data: {"id": id, "state": state},
      );

      if (!((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['code'] == 'success')) {
        throw Exception(response.data['message'] ?? 'Failed to like comment');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> postComment(int comicId, String content, {int? parentId}) async {
    try {
      final response = await dioClient.dio.post(
        '/api/comment/create',
        data: {
          "parent_id": parentId,
          "object_id": comicId,
          "object_type": 1,
          "content": content,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['code'] == 'success') {
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to post comment');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
