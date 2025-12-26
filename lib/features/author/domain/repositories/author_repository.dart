import 'package:pho_truyen/features/author/data/models/author_model.dart';

import 'package:pho_truyen/features/home/data/models/home_model.dart';

abstract class AuthorRepository {
  Future<AuthorDetailData> getAuthorDetail(int id);
  Future<List<StoryModel>> getStoriesByAuthor(
    int userId,
    int offset,
    int limit,
  );
}
