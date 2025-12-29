import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/comment/presentation/controllers/comment_controller.dart';
import 'package:pho_truyen/features/comment/presentation/widgets/comment_profile.dart';
import 'package:pho_truyen/features/dashboard/presentation/controllers/main_app_controller.dart';
import 'package:pho_truyen/shared/widgets/button/dialog_login.dart';
import '../widgets/comment_input.dart';

class CommentListPage extends StatefulWidget {
  const CommentListPage({super.key});

  @override
  State<CommentListPage> createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  late final CommentController controller;
  final int comicId = Get.arguments['comicId'];

  @override
  void initState() {
    super.initState();
    controller = Get.find<CommentController>(tag: 'comment_$comicId');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments is Map && Get.arguments['replyingTo'] != null) {
        _handleReply(Get.arguments['replyingTo']);
      }
    });
  }

  final FocusNode _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _handleReply(dynamic commentIdentity) {
    if (!Get.isRegistered<MainAppController>() ||
        !Get.find<MainAppController>().isLoggedIn.value) {
      Get.dialog(const DialogLogin());
      return;
    }
    controller.replyingToComment.value = commentIdentity;
    _inputFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textColor(context)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Bình luận',
          style: TextStyle(
            color: AppColor.textColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadComments(comicId),
              child: Obx(() {
                if (controller.isLoading.value && controller.comments.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.comments.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(
                        child: Text(
                          "Chưa có bình luận nào.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.comments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = controller.comments[index];
                    return CommentProfile(
                      comment: comment,
                      onLike: (id) => controller.likeComment(id),
                      onReply: (c) => _handleReply(c),
                    );
                  },
                );
              }),
            ),
          ),
          Obx(
            () => CommentInput(
              focusNode: _inputFocusNode,
              replyingTo: controller.replyingToComment.value?.userName,
              onCancelReply: () {
                controller.replyingToComment.value = null;
                _inputFocusNode.unfocus();
              },
              onSend: (content) {
                controller.sendComment(content);
                print("Send comment: $content");
              },
            ),
          ),
        ],
      ),
    );
  }
}
