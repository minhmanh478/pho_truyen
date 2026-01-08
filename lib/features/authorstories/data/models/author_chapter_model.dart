import '../../domain/entities/author_chapter_entity.dart';

class AuthorChapterModel extends AuthorChapterEntity {
  const AuthorChapterModel({
    required super.id,
    required super.name,
    required super.storyId,
    required super.sortOrder,
    super.publishedAt,
    required super.state,
    required super.price,
  });

  factory AuthorChapterModel.fromJson(Map<String, dynamic> json) {
    return AuthorChapterModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      storyId: json['story_id'] as int? ?? 0,
      sortOrder: json['sort_order'] as int? ?? 0,
      publishedAt: json['published_at']?.toString(),
      state: json['state']?.toString() ?? 'Draft',
      price: json['price'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'story_id': storyId,
      'sort_order': sortOrder,
      'published_at': publishedAt,
      'state': state,
      'price': price,
    };
  }
}
