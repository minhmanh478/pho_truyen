import 'package:equatable/equatable.dart';

class SearchStoryEntity extends Equatable {
  final String id;
  final String name;
  final int chapterCount;
  final String? coverImage;
  final List<String> hashtags;
  final String? slug;

  const SearchStoryEntity({
    required this.id,
    required this.name,
    required this.chapterCount,
    this.coverImage,
    required this.hashtags,
    this.slug,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    chapterCount,
    coverImage,
    hashtags,
    slug,
  ];
}
