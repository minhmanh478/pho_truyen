import '../../domain/entities/author_story_detail_entity.dart';

class AuthorStoryDetailModel extends AuthorStoryDetailEntity {
  const AuthorStoryDetailModel({super.detail, super.storyEdit, super.buttons});

  factory AuthorStoryDetailModel.fromJson(Map<String, dynamic> json) {
    return AuthorStoryDetailModel(
      detail: json['detail'] != null
          ? UserStoryDetailModel.fromJson(json['detail'])
          : null,
      storyEdit: json['story_edit'] != null
          ? UserStoryDetailModel.fromJson(json['story_edit'])
          : null,
      buttons: json['buttons'] != null
          ? (json['buttons'] as List)
                .map((e) => StoryButtonModel.fromJson(e))
                .toList()
          : null,
    );
  }
}

class UserStoryDetailModel extends UserStoryDetail {
  const UserStoryDetailModel({
    required super.id,
    required super.userId,
    super.image,
    super.name,
    super.content,
    super.description,
    super.nameSearch,
    super.slug,
    super.tags,
    super.categoryIds,
    super.tagIds,
    super.price,
    super.salePrice,
    super.chapterCount,
    super.readCount,
    super.nominations,
    super.limitAge,
    super.isBuyFull,
    super.isFull,
    super.isVip,
    super.isDraft,
    super.isSendApproved,
    super.isApproved,
    super.rejectMessage,
    super.chapterReleaseSchedule,
    super.state,
    super.stateName,
    super.stateColor,
  });

  factory UserStoryDetailModel.fromJson(Map<String, dynamic> json) {
    return UserStoryDetailModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      image: json['image'],
      name: json['name'],
      content: json['content'],
      description: json['description'],
      nameSearch: json['name_search'],
      slug: json['slug'],
      tags: json['tags'],
      categoryIds: json['category_ids'],
      tagIds: json['tag_ids'],
      price: json['price'] ?? 0,
      salePrice: json['sale_price'] ?? 0,
      chapterCount: json['chapter_count'] ?? 0,
      readCount: json['read_count'] ?? 0,
      nominations: json['nominations'] ?? 0,
      limitAge: json['limit_age'] ?? 0,
      isBuyFull: json['is_buy_full'] ?? 0,
      isFull: json['is_full'] ?? 0,
      isVip: json['is_vip'] ?? 0,
      isDraft: json['is_draft'] ?? 0,
      isSendApproved: json['is_send_approved'] ?? 0,
      isApproved: json['is_approved'] ?? 0,
      rejectMessage: json['reject_message'],
      chapterReleaseSchedule: json['chapter_release_schedule'],
      state: json['state'] ?? 0,
      stateName: json['state_name'],
      stateColor: json['state_color'],
    );
  }
}

class StoryButtonModel extends StoryButton {
  const StoryButtonModel({required super.title, required super.code});

  factory StoryButtonModel.fromJson(Map<String, dynamic> json) {
    return StoryButtonModel(
      title: json['title'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
