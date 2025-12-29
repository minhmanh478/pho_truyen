import 'package:flutter/material.dart';
import '../../domain/entities/comment_entity.dart';
import 'comment_item.dart';

class CommentProfile extends StatelessWidget {
  final CommentEntity comment;
  final Function(int)? onLike;
  final Function(CommentEntity)? onReply;

  const CommentProfile({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentItem(comment: comment, onLike: onLike, onReply: onReply),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 8),
            child: Column(
              children: comment.replies
                  .map(
                    (reply) => CommentProfile(
                      comment: reply,
                      onLike: onLike,
                      onReply: onReply,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
