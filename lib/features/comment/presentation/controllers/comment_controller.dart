import 'package:get/get.dart';
import 'package:pho_truyen/shared/widgets/button/dialog_login.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/get_comments_usecase.dart';
import '../../domain/usecases/like_comment_usecase.dart';
import 'package:pho_truyen/features/dashboard/presentation/controllers/main_app_controller.dart';
import 'package:pho_truyen/features/comment/domain/usecases/post_comment_usecase.dart';

class CommentController extends GetxController {
  final GetCommentsUseCase getCommentsUseCase;
  final LikeCommentUseCase likeCommentUseCase;
  final PostCommentUseCase postCommentUseCase;

  CommentController({
    required this.getCommentsUseCase,
    required this.likeCommentUseCase,
    required this.postCommentUseCase,
  });

  final RxList<CommentEntity> comments = <CommentEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<CommentEntity?> replyingToComment = Rx<CommentEntity?>(null);

  // comment
  Future<void> sendComment(String content) async {
    if (!Get.isRegistered<MainAppController>() ||
        !Get.find<MainAppController>().isLoggedIn.value) {
      Get.dialog(const DialogLogin());
      return;
    }

    var args = Get.arguments;
    int? comicId;
    if (args is int) {
      comicId = args;
    } else if (args is Map && args.containsKey('comicId')) {
      comicId = args['comicId'];
    }

    if (comicId == null) {
      Get.snackbar("Lỗi", "Không tìm thấy ID truyện");
      return;
    }

    final result = await postCommentUseCase(
      PostCommentParams(
        comicId: comicId,
        content: content,
        parentId: replyingToComment.value?.id,
      ),
    );

    result.fold(
      (failure) {
        Get.snackbar("Lỗi", "Không thể gửi bình luận: ${failure.message}");
      },
      (success) {
        // Reload comments to show the new one
        replyingToComment.value = null; // Clear reply state
        loadComments(comicId!);
      },
    );
  }

  Future<void> loadComments(int comicId) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getCommentsUseCase(comicId);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (data) {
        comments.assignAll(data);
        isLoading.value = false;
      },
    );
  }

  Future<void> likeComment(int commentId) async {
    if (!Get.isRegistered<MainAppController>() ||
        !Get.find<MainAppController>().isLoggedIn.value) {
      Get.dialog(const DialogLogin());
      return;
    }

    CommentEntity? targetComment;

    // Tìm ở cấp cao nhất
    var index = comments.indexWhere((c) => c.id == commentId);
    if (index != -1) {
      targetComment = comments[index];
    } else {
      // Tìm trong câu trả lời
      for (var parent in comments) {
        var replyIndex = parent.replies.indexWhere((r) => r.id == commentId);
        if (replyIndex != -1) {
          targetComment = parent.replies[replyIndex];
          break;
        }
      }
    }

    if (targetComment == null) return;

    final newState = targetComment.isLiked ? 0 : 1;
    final newLikeCount = newState == 1
        ? targetComment.likeCount + 1
        : targetComment.likeCount - 1;
    print(' ID: $commentId, State: $newState');
    final result = await likeCommentUseCase(
      LikeCommentParams(id: commentId, state: newState),
    );

    result.fold(
      (failure) {
        Get.snackbar("Lỗi", "Không thể thích bình luận: ${failure.message}");
      },
      (_) {
        _updateLocalCommentState(commentId, newState == 1, newLikeCount);
      },
    );
  }

  void _updateLocalCommentState(int id, bool isLiked, int likeCount) {
    // Kiểm tra cấp cao nhất
    int index = comments.indexWhere((c) => c.id == id);
    if (index != -1) {
      final oldComment = comments[index];
      final updatedComment = _createNewComment(oldComment, isLiked, likeCount);
      comments[index] = updatedComment;
      comments.refresh();
      return;
    }

    // Kiểm tra câu trả lời
    for (int i = 0; i < comments.length; i++) {
      var parent = comments[i];
      int replyIndex = parent.replies.indexWhere((r) => r.id == id);
      if (replyIndex != -1) {
        var oldReply = parent.replies[replyIndex];
        var updatedReply = _createNewComment(oldReply, isLiked, likeCount);
        List<CommentEntity> newReplies = List.from(parent.replies);
        newReplies[replyIndex] = updatedReply;

        final updatedParent = CommentEntity(
          id: parent.id,
          userId: parent.userId,
          content: parent.content,
          userName: parent.userName,
          userAvatar: parent.userAvatar,
          createdAt: parent.createdAt,
          parentId: parent.parentId,
          childCount: parent.childCount,
          likeCount: parent.likeCount,
          isLiked: parent.isLiked,
          replies: newReplies,
        );

        comments[i] = updatedParent;
        comments.refresh();
        return;
      }
    }
  }

  CommentEntity _createNewComment(
    CommentEntity old,
    bool isLiked,
    int likeCount,
  ) {
    return CommentEntity(
      id: old.id,
      userId: old.userId,
      content: old.content,
      userName: old.userName,
      userAvatar: old.userAvatar,
      createdAt: old.createdAt,
      parentId: old.parentId,
      childCount: old.childCount,
      likeCount: likeCount,
      isLiked: isLiked,
      replies: old.replies,
    );
  }
}
