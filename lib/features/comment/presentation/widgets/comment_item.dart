import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/core/utils/date_time_extension.dart';
import 'package:pho_truyen/shared/widgets/button/dialog_login.dart';
import 'package:pho_truyen/features/users/presentation/widgets/info_user/info_user_avatar.dart';

import '../../domain/entities/comment_entity.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  final Function(int)? onLike;
  final Function(CommentEntity)? onReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.backgroundDark1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoUserAvatar(
              avatarUrl: comment.userAvatar,
              isDarkMode: Theme.of(context).brightness == Brightness.dark,
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8EB),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.content,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 8),
                    child: Row(
                      children: [
                        Text(
                          comment.createdAt.timeAgo,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _buildActionButton(
                          "Thích (${comment.likeCount})",
                          onTap: () {
                            if (onLike != null) {
                              onLike!(comment.id);
                            }
                          },
                          isLiked: comment.isLiked,
                        ),
                        const SizedBox(width: 6),
                        _buildActionButton(
                          "Trả lời${comment.childCount > 0 ? ' (${comment.childCount})' : ''}",
                          onTap: () {
                            if (onReply != null) {
                              onReply!(comment);
                            } else {
                              Get.dialog(const DialogLogin());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label, {
    VoidCallback? onTap,
    bool isLiked = false,
  }) {
    return TextButton(
      onPressed: onTap ?? () => Get.dialog(const DialogLogin()),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: isLiked ? AppColor.primaryColor : Colors.grey,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isLiked ? AppColor.primaryColor : Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
