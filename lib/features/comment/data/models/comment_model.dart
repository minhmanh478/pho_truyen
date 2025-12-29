import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.userId,
    required super.content,
    required super.userName,
    super.userAvatar,
    required super.createdAt,
    super.parentId,
    super.childCount,
    super.likeCount,
    super.isLiked,
    super.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    var repliesList = <CommentModel>[];
    if (json['comments'] != null) {
      json['comments'].forEach((v) {
        repliesList.add(CommentModel.fromJson(v));
      });
    }

    return CommentModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      content: json['content'] ?? '',
      userName: json['full_name'] ?? 'Unknown',
      userAvatar: json['avatar'],
      createdAt: json['time_create'] ?? '',
      parentId: json['parent_id'] ?? 0,
      childCount: json['child_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
      replies: repliesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'full_name': userName,
      'avatar': userAvatar,
      'time_create': createdAt,
      'parent_id': parentId,
      'child_count': childCount,
      'like_count': likeCount,
      'is_liked': isLiked ? 1 : 0,
      'comments': replies.map((e) => (e as CommentModel).toJson()).toList(),
    };
  }
}
