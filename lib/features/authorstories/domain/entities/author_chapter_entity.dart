import 'package:equatable/equatable.dart';

class AuthorChapterEntity extends Equatable {
  final int id;
  final String name;
  final int storyId;
  final int sortOrder;
  final String? publishedAt;
  final String state;
  final int price;

  const AuthorChapterEntity({
    required this.id,
    required this.name,
    required this.storyId,
    required this.sortOrder,
    this.publishedAt,
    required this.state,
    required this.price,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    storyId,
    sortOrder,
    publishedAt,
    state,
    price,
  ];
}
