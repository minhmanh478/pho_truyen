import '../../domain/entities/user_story_entity.dart';

class UserStoryModel extends UserStoryEntity {
  UserStoryModel({
    required super.id,
    required super.name,
    super.image,
    super.content,
    super.description,
    super.chapterReleaseSchedule,
    super.slug,
    super.chapterCount,
    super.chapterAuthorCount,
    super.readCount,
    super.commentCount,
    super.nominations,
    super.stateName,
    super.stateColor,
    super.timeUpdate,
  });

  factory UserStoryModel.fromJson(Map<String, dynamic> json) {
    return UserStoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      content: json['content'],
      description: json['description'],
      chapterReleaseSchedule: json['chapter_release_schedule'],
      slug: json['slug'],
      chapterCount: json['chapter_count'] ?? 0,
      chapterAuthorCount: json['chapter_author_count'] ?? 0,
      readCount: json['read_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      nominations: json['nominations'] ?? 0,
      stateName: json['state_name'] ?? 'Truyện nháp',
      stateColor: json['state_color'] ?? '4db6ac',
      timeUpdate: json['time_update'] != null
          ? DateTime.tryParse(json['time_update'])
          : null,
    );
  }
}
