import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/features/authorstories/presentation/controllers/edit_chapter_controller.dart';
import 'package:pho_truyen/features/users/presentation/widgets/custom_text_field.dart';
import '../../../../../../core/constants/app_color.dart';

class EditChapterPage extends GetView<EditChapterController> {
  const EditChapterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundDark1, // Ensure dark background
      appBar: AppBar(
        title: Text(
          controller.isCreateMode ? 'Thêm Chương' : 'Sửa Chương',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.slate900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(context, 'Tên chương', isRequired: true),
            const SizedBox(height: 8),
            CustomTextField(
              controller: controller.nameController,
              hintText: 'Nhập tên chương',
              fillColor: AppColor.inputFillColor(context),
              textColor: AppColor.textColor(context),
            ),
            const SizedBox(height: 16),
            _buildLabel(
              context,
              'Nội dung chương',
              isRequired: true,
              hasExpandIcon: true,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: controller.contentController,
              hintText: 'Nhập nội dung chương',
              maxLines: 10,
              fillColor: AppColor.inputFillColor(context),
              textColor: AppColor.textColor(context),
            ),
            const SizedBox(height: 16),
            _buildLabel(context, 'Chú giải'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: controller.noteController,
              hintText: 'Nhập chú giải',
              maxLines: 5,
              fillColor: AppColor.inputFillColor(context),
              textColor: AppColor.textColor(context),
            ),
            const SizedBox(height: 16),
            _buildLabel(context, 'Khóa chương (chương 21 trở đi)'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColor.inputFillColor(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent),
              ),
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.selectedPrice.value,
                    isExpanded: true,
                    dropdownColor: AppColor.slate900,
                    style: TextStyle(color: AppColor.textColor(context)),
                    items: List.generate(40, (i) => i * 1).map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text("$value"),
                      );
                    }).toList(),
                    onChanged: (val) => controller.updatePrice(val),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.updateChapter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor
                        .primary, // Use primary color for better visibility
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Lưu',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(
    BuildContext context,
    String text, {
    bool isRequired = false,
    bool hasExpandIcon = false,
  }) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textColor(context),
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        if (hasExpandIcon) ...[
          const Spacer(),
          Icon(Icons.fullscreen, color: AppColor.textColor(context)),
        ],
      ],
    );
  }
}
