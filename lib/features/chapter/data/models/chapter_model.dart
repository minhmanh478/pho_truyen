class ChapterDetailResponse {
  final String code;
  final String message;
  final ChapterDetailData? data;

  ChapterDetailResponse({required this.code, required this.message, this.data});

  factory ChapterDetailResponse.fromJson(Map<String, dynamic> json) {
    return ChapterDetailResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ChapterDetailData.fromJson(json['data'])
          : null,
    );
  }
}

class ChapterDetailData {
  final ChapterDetailModel? detail;

  ChapterDetailData({this.detail});

  factory ChapterDetailData.fromJson(Map<String, dynamic> json) {
    return ChapterDetailData(
      detail: json['detail'] != null
          ? ChapterDetailModel.fromJson(json['detail'])
          : null,
    );
  }
}

class ChapterDetailModel {
  final int id;
  final int storyId;
  final int chapterNumber;
  final String name;
  final String? content;
  final int readCount;

  ChapterDetailModel({
    required this.id,
    required this.storyId,
    required this.chapterNumber,
    required this.name,
    this.content,
    required this.readCount,
  });

  factory ChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return ChapterDetailModel(
      id: json['id'] ?? 0,
      storyId: json['story_id'] ?? 0,
      chapterNumber: json['chapter_number'] ?? 0,
      name: json['name'] ?? '',
      content: json['content'],
      readCount: json['read_count'] ?? 0,
    );
  }
}
