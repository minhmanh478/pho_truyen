class CreateStoryRequest {
  final int? id;
  final String image;
  final String name;
  final String content;
  final String description;
  final String categoryIds;
  final String chapterReleaseSchedule;
  final String tagIds;
  final int limitAge;

  CreateStoryRequest({
    this.id,
    required this.image,
    required this.name,
    required this.content,
    this.description = '',
    required this.categoryIds,
    required this.chapterReleaseSchedule,
    required this.tagIds,
    this.limitAge = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'image': image,
      'name': name,
      'content': content,
      'description': description,
      'category_ids': categoryIds,
      'chapter_release_schedule': chapterReleaseSchedule,
      'tag_ids': tagIds,
      'limit_age': limitAge,
    };
  }
}
