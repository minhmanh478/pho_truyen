import 'package:pho_truyen/features/home/data/models/home_model.dart';

class AuthorDetailResponse {
  final String code;
  final String message;
  final AuthorDetailData? data;

  AuthorDetailResponse({required this.code, required this.message, this.data});

  factory AuthorDetailResponse.fromJson(Map<String, dynamic> json) {
    return AuthorDetailResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AuthorDetailData.fromJson(json['data'])
          : null,
    );
  }
}

class AuthorDetailData {
  final AuthorModel author;
  final List<StoryModel> listStory;

  AuthorDetailData({required this.author, required this.listStory});

  factory AuthorDetailData.fromJson(Map<String, dynamic> json) {
    return AuthorDetailData(
      author: AuthorModel.fromJson(json['author'] ?? {}),
      listStory:
          (json['list_story'] as List?)
              ?.map((e) => StoryModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AuthorModel {
  final int id;
  final String fullName;
  final String? avatar;
  final int authorLevel;
  final String? introduce;
  final String? notification;
  final String authorLevelName;
  final int followCount;
  final int isFollow;
  final int totalStory;

  AuthorModel({
    required this.id,
    required this.fullName,
    this.avatar,
    this.authorLevel = 0,
    this.introduce,
    this.notification,
    this.authorLevelName = '',
    this.followCount = 0,
    this.isFollow = 0,
    this.totalStory = 0,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      avatar: json['avatar'],
      authorLevel: json['author_level'] ?? 0,
      introduce: json['introduce'],
      notification: json['notification'],
      authorLevelName: json['author_level_name'] ?? '',
      followCount: json['follow_count'] ?? 0,
      isFollow: json['is_follow'] ?? 0,
      totalStory: json['total_story'] ?? 0,
    );
  }
}
