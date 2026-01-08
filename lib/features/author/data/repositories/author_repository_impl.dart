import 'package:pho_truyen/features/author/data/datasources/author_remote_data_source.dart';
import 'package:pho_truyen/features/author/data/models/author_model.dart';
import 'package:pho_truyen/features/author/domain/repositories/author_repository.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final AuthorRemoteDataSource remoteDataSource;

  AuthorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthorDetailData> getAuthorDetail(int id) async {
    final response = await remoteDataSource.getAuthorDetail(id);
    if (response.data != null) {
      return response.data!;
    } else {
      throw Exception('Data is null');
    }
  }

  @override
  Future<List<StoryModel>> getStoriesByAuthor(
    int userId,
    int offset,
    int limit,
  ) async {
    final response = await remoteDataSource.getStoriesByAuthor(
      userId,
      offset,
      limit,
    );
    return response.map((e) => StoryModel.fromJson(e)).toList();
  }

  @override
  Future<bool> followAuthor(int id, int state) async {
    return await remoteDataSource.followAuthor(id, state);
  }
}
