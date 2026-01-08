import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/constants/app_color.dart';
// import '../../../../../../shared/widgets/custom_image.dart';
import '../../controllers/post_new_story_controller.dart';
import 'post_new_story_widgets.dart';

class PostNewStoryPage extends StatelessWidget {
  const PostNewStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is now injected via Binding
    final controller = Get.find<PostNewStoryController>();

    final isDarkMode = AppColor.isDarkMode(context);
    final textColor = AppColor.textColor(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm Truyện Mới',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.transparent : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PostNewStorySectionTitle(title: 'Thể loại truyện *'),
              const SizedBox(height: 8),
              PostNewStoryCategoryDropdown(controller: controller),

              const SizedBox(height: 16),
              const PostNewStorySectionTitle(title: 'Tên tác phẩm *'),
              const SizedBox(height: 8),
              PostNewStoryTextField(
                controller: controller.nameController,
                hint: 'Nhập tên tác phẩm',
              ),

              const SizedBox(height: 16),
              const PostNewStorySectionTitle(title: 'Giới thiệu về truyện'),
              const SizedBox(height: 8),
              PostNewStoryTextField(
                controller: controller.descriptionController,
                hint: 'Nhập giới thiệu về truyện',
                maxLines: 5,
              ),

              const SizedBox(height: 16),
              const PostNewStorySectionTitle(title: 'Chọn tag (tối đa 3) *'),
              const SizedBox(height: 8),
              PostNewStoryTagSelector(
                selectedTags: controller.selectedTags,
                tags: controller.tags,
                onToggleTag: controller.toggleTag,
              ),

              const SizedBox(height: 16),
              const PostNewStorySectionTitle(title: 'Ảnh đại diện'),
              const SizedBox(height: 8),
              _buildImagePicker(controller, isDarkMode),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitStory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  // Keeping ImagePicker specific widget here as it's small and depends on potential package import
  Widget _buildImagePicker(PostNewStoryController controller, bool isDarkMode) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          controller.uploadImage(File(image.path));
        }
      },
      child: Obx(() {
        if (controller.selectedImagePath.value.isNotEmpty) {
          return Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(controller.selectedImagePath.value)),
                fit: BoxFit.cover,
              ),
            ),
          );
        }
        return Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColor.cardColor : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(Icons.image, size: 40, color: Colors.grey.shade400),
          ),
        );
      }),
    );
  }
}
