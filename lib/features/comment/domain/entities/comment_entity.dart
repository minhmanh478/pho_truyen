import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final int id;
  final int userId;
  final String content;
  final String userName;
  final String? userAvatar;
  final String createdAt;

  final int parentId;
  final int childCount;
  final int likeCount;
  final bool isLiked;
  final List<CommentEntity> replies;

  const CommentEntity({
    required this.id,
    required this.userId,
    required this.content,
    required this.userName,
    this.userAvatar,
    required this.createdAt,
    this.parentId = 0,
    this.childCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.replies = const [],
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    content,
    userName,
    userAvatar,
    createdAt,
    parentId,
    childCount,
    likeCount,
    isLiked,
    replies,
  ];
}
