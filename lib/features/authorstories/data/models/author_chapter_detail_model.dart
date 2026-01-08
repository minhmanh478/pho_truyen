import '../../domain/entities/author_chapter_detail_entity.dart';
import '../models/author_story_detail_model.dart';

class AuthorChapterDetailModel extends AuthorChapterDetailEntity {
  const AuthorChapterDetailModel({
    required super.id,
    required super.appId,
    required super.userId,
    required super.storyId,
    required super.chapterNumber,
    super.image,
    required super.name,
    required super.slug,
    super.content,
    super.description,
    super.nameSearch,
    super.note,
    required super.adultContent,
    required super.isLock,
    required super.price,
    required super.salePrice,
    required super.order,
    required super.readCount,
    required super.isDraft,
    required super.isSendApproved,
    required super.isApproved,
    super.rejectMessage,
    required super.type,
    required super.state,
    super.timeUpdate,
    super.timeCreate,
    super.stateName,
    super.stateColor,
  });

  factory AuthorChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return AuthorChapterDetailModel(
      id: json['id'] as int? ?? 0,
      appId: json['app_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      storyId: json['story_id'] as int? ?? 0,
      chapterNumber: json['chapter_number'] as int? ?? 0,
      image: json['image'] as String?,
      name: json['name']?.toString() ?? '',
      slug: json['slug'] as String? ?? '',
      content: json['content'] as String?,
      description: json['description'] as String?,
      nameSearch: json['name_search'] as String?,
      note: json['note'] as String?,
      adultContent: json['adult_content'] as int? ?? 0,
      isLock: json['is_lock'] as int? ?? 0,
      price: json['price'] as int? ?? 0,
      salePrice: json['sale_price'] as int? ?? 0,
      order: json['order'] as int? ?? 0,
      readCount: json['read_count'] as int? ?? 0,
      isDraft:
          json['is_drart'] as int? ?? 0, // Note possible typo in API 'drart'
      isSendApproved: json['is_send_approved'] as int? ?? 0,
      isApproved: json['is_approved'] as int? ?? 0,
      rejectMessage: json['reject_message'] as String?,
      type: json['type'] as int? ?? 0,
      state: json['state'] as int? ?? 0,
      timeUpdate: json['time_update'] as String?,
      timeCreate: json['time_create'] as String?,
      stateName: json['state_name'] as String?,
      stateColor: json['state_color'] as String?,
    );
  }
}

class AuthorChapterDetailResultModel extends AuthorChapterDetailResultEntity {
  const AuthorChapterDetailResultModel({required super.detail, super.buttons});

  factory AuthorChapterDetailResultModel.fromJson(Map<String, dynamic> json) {
    return AuthorChapterDetailResultModel(
      detail: AuthorChapterDetailModel.fromJson(
        json['detail'] as Map<String, dynamic>,
      ),
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => StoryButtonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
