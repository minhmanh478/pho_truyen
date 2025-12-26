class StoryModel {
  final int id;
  final int userId;
  final String name;
  final String? image;
  final String? content;
  final String? description;
  final int chapterCount;
  final int readCount;
  final int commentCount;
  final int nominations;
  final String? authorName;
  final String? authorAvatar;
  final List<StoryHashtag> hashtags;
  final int isVip;
  final int isFull;
  final String? chapterReleaseSchedule;
  final int appId;
  final String? slug;
  final int totalPriceBuy;
  final int chapterAuthorCount;
  final int? currentChapterId;
  final String? currentChapterName;
  final num? currentChapterNumber;

  StoryModel({
    required this.id,
    required this.userId,
    required this.name,
    this.image,
    this.content,
    this.description,
    this.chapterCount = 0,
    this.readCount = 0,
    this.commentCount = 0,
    this.nominations = 0,
    this.authorName,
    this.authorAvatar,
    this.hashtags = const [],
    this.isVip = 0,
    this.isFull = 0,
    this.chapterReleaseSchedule,
    this.appId = 0,
    this.slug,
    this.totalPriceBuy = 0,
    this.chapterAuthorCount = 0,
    this.currentChapterId,
    this.currentChapterName,
    this.currentChapterNumber,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      content: json['content'],
      description: json['description'],
      chapterCount: json['chapter_count'] ?? 0,
      readCount: json['read_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      nominations: json['nominations'] ?? 0,
      authorName: json['full_name'],
      authorAvatar: json['avatar'],
      hashtags:
          (json['hashtags'] as List?)
              ?.map((x) => StoryHashtag.fromJson(x))
              .toList() ??
          [],
      isVip: json['is_vip'] ?? 0,
      isFull: json['is_full'] ?? 0,
      chapterReleaseSchedule: json['chapter_release_schedule'],
      appId: json['app_id'] ?? 0,
      slug: json['slug'],
      totalPriceBuy: json['total_price_buy'] ?? 0,
      chapterAuthorCount: json['chapter_author_count'] ?? 0,
      currentChapterId: json['current_chapter_id'] ?? json['chapter_id'],
      currentChapterName: json['current_chapter_name'] ?? json['chapter_name'],
      currentChapterNumber:
          json['current_chapter_number'] ?? json['chapter_number'],
    );
  }
}

class StoryHashtag {
  final String name;
  final String color;

  StoryHashtag({required this.name, required this.color});

  factory StoryHashtag.fromJson(Map<String, dynamic> json) {
    return StoryHashtag(
      name: json['name'] ?? '',
      color: json['color'] ?? '000000', // Default black
    );
  }
}
