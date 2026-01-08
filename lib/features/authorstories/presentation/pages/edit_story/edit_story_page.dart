import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../../core/constants/app_color.dart';
import '../../controllers/edit_story_controller.dart';
import '../post_new_story/post_new_story_widgets.dart';

class EditStoryPage extends StatelessWidget {
  const EditStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is injected via Binding
    final controller = Get.find<EditStoryController>();

    final isDarkMode = AppColor.isDarkMode(context);
    final textColor = isDarkMode ? Colors.white : AppColor.textColor(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chỉnh sửa truyện',
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
              _buildCategoryDropdown(
                categories: controller.categories,
                selectedCategory: controller.selectedCategory.value,
                onChanged: controller.onCategoryChanged,
                isDarkMode: isDarkMode,
                textColor: textColor,
              ),

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
              _buildImagePicker(
                imagePath: controller.selectedImagePath.value,
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    controller.uploadImage(File(image.path));
                  }
                },
                isDarkMode: isDarkMode,
              ),

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
                    'Lưu thay đổi',
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

  Widget _buildCategoryDropdown({
    required List<String> categories,
    required String selectedCategory,
    required ValueChanged<String?> onChanged,
    required bool isDarkMode,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColor.cardColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory.isEmpty ? null : selectedCategory,
          hint: Text(
            'Chọn thể loại',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          dropdownColor: isDarkMode ? AppColor.cardColor : Colors.white,
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category, style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String imagePath,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Builder(
        builder: (context) {
          if (imagePath.isNotEmpty) {
            final isNetwork = imagePath.startsWith('http');

            return Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isNetwork
                    ? CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Image.file(File(imagePath), fit: BoxFit.cover),
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
        },
      ),
    );
  }
}
