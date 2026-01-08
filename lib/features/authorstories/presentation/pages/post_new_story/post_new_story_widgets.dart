// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_color.dart';
import 'package:get/get.dart';
import '../../controllers/post_new_story_controller.dart';

class PostNewStorySectionTitle extends StatelessWidget {
  final String title;

  const PostNewStorySectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textColor = AppColor.textColor(context);
    return RichText(
      text: TextSpan(
        text: title.replaceAll('*', ''),
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        children: [
          if (title.contains('*'))
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}

class PostNewStoryTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const PostNewStoryTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final textColor = AppColor.textColor(context);

    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: isDarkMode ? AppColor.cardColor : Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class PostNewStoryCategoryDropdown extends StatelessWidget {
  final PostNewStoryController controller;

  const PostNewStoryCategoryDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final textColor = AppColor.textColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColor.cardColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            value: controller.selectedCategory.value.isEmpty
                ? null
                : controller.selectedCategory.value,
            hint: Text(
              'Chọn thể loại truyện',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
            isExpanded: true,
            isDense: true,
            padding: const EdgeInsets.symmetric(vertical: 12),
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            dropdownColor: isDarkMode ? AppColor.cardColor : Colors.white,
            items: controller.categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              );
            }).toList(),
            onChanged: controller.onCategoryChanged,
          ),
        ),
      ),
    );
  }
}

class PostNewStoryTagSelector extends StatelessWidget {
  final RxList<String> selectedTags;
  final RxList<Map<String, dynamic>> tags;
  final Function(String) onToggleTag;

  const PostNewStoryTagSelector({
    super.key,
    required this.selectedTags,
    required this.tags,
    required this.onToggleTag,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final textColor = AppColor.textColor(context);

    return InkWell(
      onTap: () {
        _showTagSelectionDialog(context, isDarkMode, textColor);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColor.cardColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(() {
                if (selectedTags.isEmpty) {
                  return Text(
                    'Chọn tag',
                    style: TextStyle(color: Colors.grey.shade500),
                  );
                }
                return Wrap(
                  spacing: 8,
                  children: selectedTags.map((id) {
                    final tagName = tags.firstWhere(
                      (t) => t['id'] == id,
                      orElse: () => {'name': ''},
                    )['name'];
                    return Chip(
                      label: Text(tagName, style: TextStyle(color: textColor)),
                      backgroundColor: isDarkMode
                          ? AppColor.primary.withOpacity(0.2)
                          : null,
                      side: BorderSide.none,
                      deleteIconColor: textColor,
                      deleteIcon: Icon(Icons.close, size: 16),
                      onDeleted: () => onToggleTag(id),
                    );
                  }).toList(),
                );
              }),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  void _showTagSelectionDialog(
    BuildContext context,
    bool isDarkMode,
    Color textColor,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: isDarkMode ? AppColor.cardColor : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chọn Tag (Tối đa 3)',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: Obx(
                  () => ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      final tag = tags[index];
                      final isSelected = selectedTags.contains(tag['id']);
                      return CheckboxListTile(
                        title: Text(
                          tag['name'],
                          style: TextStyle(color: textColor),
                        ),
                        value: isSelected,
                        onChanged: (_) => onToggleTag(tag['id']),
                        activeColor: AppColor.primary,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Xong'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
