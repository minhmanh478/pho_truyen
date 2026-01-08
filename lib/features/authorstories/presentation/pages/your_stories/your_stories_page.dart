import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/router/app_routes.dart';
import '../../../../../../core/constants/app_color.dart';
import '../../controllers/author_stories_controller.dart';
import '../../widgets/your_story_item.dart';

class YourStoriesPage extends StatelessWidget {
  const YourStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final Color textColor = AppColor.textColor(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Colors.transparent
            : Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Danh truyện của bạn',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AuthorStoriesController>(
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(controller.errorMessage.value),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.fetchStories,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (controller.stories.isEmpty) {
              return const Center(child: Text('Bạn chưa có truyện nào.'));
            }

            return RefreshIndicator(
              onRefresh: controller.fetchStories,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.stories.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final story = controller.stories[index];
                  return YourStoryItem(
                    story: story,
                    onTap: () {
                      print('Truyện ID: ${story.id}');
                      Get.toNamed(AppRoutes.yourStoryDetail, arguments: story);
                    },
                  );
                },
              ),
            );
          });
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.postNewStory),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Đăng truyện mới",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
