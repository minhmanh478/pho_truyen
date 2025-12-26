// ignore_for_file: use_super_parameters

import '../../domain/entities/search_story_entity.dart';

class SearchStoryModel extends SearchStoryEntity {
  const SearchStoryModel({
    required String id,
    required String name,
    required int chapterCount,
    String? coverImage,
    required List<String> hashtags,
    String? slug,
  }) : super(
         id: id,
         name: name,
         chapterCount: chapterCount,
         coverImage: coverImage,
         hashtags: hashtags,
         slug: slug,
       );

  factory SearchStoryModel.fromJson(Map<String, dynamic> json) {
    return SearchStoryModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] ?? '',
      chapterCount: int.tryParse(json['chapter_count']?.toString() ?? '0') ?? 0,
      coverImage: json['cover_image'] ?? json['image'],
      hashtags:
          (json['hashtags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      slug: json['slug'],
    );
  }
}
