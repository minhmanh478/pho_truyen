class UserStoryRequest {
  final String search;
  final int offset;
  final int limit;

  UserStoryRequest({this.search = '', this.offset = 0, this.limit = 20});

  Map<String, dynamic> toJson() {
    return {'search': search, 'offset': offset, 'limit': limit};
  }
}
