class ComicDetailResponse {
  final String code;
  final String message;
  final ComicDetailModel? data;

  ComicDetailResponse({required this.code, required this.message, this.data});

  factory ComicDetailResponse.fromJson(Map<String, dynamic> json) {
    return ComicDetailResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ComicDetailModel.fromJson(json['data'])
          : null,
    );
  }
}

class ComicDetailModel {
  final int id;
  final String name;
  final String? image;
  final String? content;
  final String? description;
  final int authorId;
  final String? authorName;
  final int authorFollowers;
  final String? authorAvatar;
  final int chapterCount;
  final int readCount;
  final int nominations;
  final List<String> genres;
  final List<String> hashtags;
  final List<ChapterModel> chapters;

  ComicDetailModel({
    required this.id,
    required this.name,
    this.image,
    this.content,
    this.description,
    this.authorId = 0,
    this.authorName,
    this.authorFollowers = 0,
    this.authorAvatar,
    this.chapterCount = 0,
    this.readCount = 0,
    this.nominations = 0,
    this.genres = const [],
    this.hashtags = const [],
    this.chapters = const [],
  });

  factory ComicDetailModel.fromJson(Map<String, dynamic> json) {
    final detail = json['detail'] ?? {};
    final author = json['author'] ?? {};
    final listTag = json['list_tag'] as List? ?? [];

    return ComicDetailModel(
      id: detail['id'] ?? 0,
      name: detail['name'] ?? '',
      image: detail['image'],
      content: detail['content'],
      description: detail['description'] ?? detail['seo_description'],
      authorId: author['id'] ?? 0,
      authorName: author['full_name'],
      authorFollowers: author['follow_count'] ?? 0,
      authorAvatar: author['avatar'],
      chapterCount: detail['chapter_count'] ?? 0,
      readCount: detail['read_count'] ?? 0,
      nominations: detail['nominations'] ?? 0,
      genres: listTag.map((e) => e['name'] as String).toList(),
      hashtags:
          (detail['hashtags'] as List?)
              ?.map((e) => e['name'] as String)
              .toList() ??
          [],
      chapters: [],
    );
  }
}

class ComicChaptersResponse {
  final String code;
  final String message;
  final List<ChapterModel> data;

  ComicChaptersResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ComicChaptersResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['items'] as List? ?? [];
    List<ChapterModel> chapters = list
        .map((i) => ChapterModel.fromJson(i))
        .toList();
    return ComicChaptersResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: chapters,
    );
  }
}

class ChapterModel {
  final int id;
  final int chapterNumber;
  final String name;
  final int isLock;
  final int price;
  final int salePrice;
  final int isRead;

  ChapterModel({
    required this.id,
    required this.chapterNumber,
    required this.name,
    required this.isLock,
    required this.price,
    required this.salePrice,
    required this.isRead,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] ?? 0,
      chapterNumber: json['chapter_number'] ?? 0,
      name: json['name'] ?? '',
      isLock: json['is_lock'] ?? 0,
      price: json['price'] ?? 0,
      salePrice: json['sale_price'] ?? 0,
      isRead: json['is_read'] ?? 0,
    );
  }
}
