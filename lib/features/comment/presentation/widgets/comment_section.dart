import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/network/api_client.dart';
import 'package:pho_truyen/features/comment/data/datasources/comment_remote_datasource.dart';
import 'package:pho_truyen/features/comment/data/repositories/comment_repository_impl.dart';
import 'package:pho_truyen/features/comment/domain/usecases/get_comments_usecase.dart';
import 'package:pho_truyen/features/comment/domain/usecases/like_comment_usecase.dart';
import 'package:pho_truyen/features/comment/domain/usecases/post_comment_usecase.dart';
import 'package:pho_truyen/features/dashboard/presentation/controllers/main_app_controller.dart';
import 'package:pho_truyen/shared/widgets/button/dialog_login.dart';
import '../controllers/comment_controller.dart';
import 'comment_item.dart';

class CommentSection extends StatelessWidget {
  final int comicId;

  const CommentSection({super.key, required this.comicId});

  @override
  Widget build(BuildContext context) {
    final commentController = Get.put(
      CommentController(
        getCommentsUseCase: GetCommentsUseCase(
          CommentRepositoryImpl(
            remoteDataSource: CommentRemoteDataSourceImpl(
              dioClient: DioClient(),
            ),
          ),
        ),
        likeCommentUseCase: LikeCommentUseCase(
          CommentRepositoryImpl(
            remoteDataSource: CommentRemoteDataSourceImpl(
              dioClient: DioClient(),
            ),
          ),
        ),
        postCommentUseCase: PostCommentUseCase(
          CommentRepositoryImpl(
            remoteDataSource: CommentRemoteDataSourceImpl(
              dioClient: DioClient(),
            ),
          ),
        ),
      ),
      tag: 'comment_$comicId',
    );
    if (commentController.comments.isEmpty) {
      commentController.loadComments(comicId);
    }

    return Obx(() {
      if (commentController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (commentController.comments.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              "Chưa có bình luận nào.",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        );
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bình luận',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(
                    '/comment-list',
                    arguments: {'comicId': comicId},
                  ),
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: commentController.comments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 320,
                    child: CommentItem(
                      comment: comment,
                      onLike: (id) => commentController.likeComment(id),
                      onReply: (comment) {
                        if (!Get.isRegistered<MainAppController>() ||
                            !Get.find<MainAppController>().isLoggedIn.value) {
                          Get.dialog(const DialogLogin());
                          return;
                        }
                        Get.toNamed(
                          '/comment-list',
                          arguments: {
                            'comicId': comicId,
                            'replyingTo': comment,
                          },
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}
