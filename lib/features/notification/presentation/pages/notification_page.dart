// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller = Get.find<NotificationController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.fetchNotifications();
    }
  }

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
          icon: Icon(Icons.arrow_back, color: AppColor.textColor(context)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Thông báo',
          style: TextStyle(
            color: AppColor.textColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Text(
              'Chưa có thông báo nào',
              style: TextStyle(color: textColor),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(isRefresh: true),
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.notifications.length +
                (controller.hasMore.value ? 1 : 0),
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            itemBuilder: (context, index) {
              if (index == controller.notifications.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final notification = controller.notifications[index];
              return NotificationItem(
                notification: notification,
                textColor: textColor,
              );
            },
          ),
        );
      }),
    );
  }
}
