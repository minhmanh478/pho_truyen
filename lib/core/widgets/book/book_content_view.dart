import 'package:flutter/material.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/features/story/presentation/widgets/book/book_grid_item.dart';
import 'package:pho_truyen/features/story/presentation/widgets/book/book_list_item.dart';

import 'package:pho_truyen/core/router/app_routes.dart';

class BookContentView extends StatelessWidget {
  final List data;
  final bool isGridView;

  const BookContentView({
    super.key,
    required this.data,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color subColor = isDarkMode ? Colors.white70 : AppColor.slate600;

    if (data.isEmpty) {
      return Center(
        child: Text("Chưa có dữ liệu", style: TextStyle(color: subColor)),
      );
    }

    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 20,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                Get.toNamed(AppRoutes.comicDetail, arguments: data[index].id),
            child: BookGridItem(item: data[index]),
          );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () =>
              Get.toNamed(AppRoutes.comicDetail, arguments: data[index].id),
          child: BookListItem(item: data[index]),
        );
      },
    );
  }
}
