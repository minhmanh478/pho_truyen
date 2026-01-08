import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationEntity? notification = Get.arguments;

    if (notification == null) {
      return const Scaffold(
        body: Center(child: Text("Không tìm thấy thông tin thông báo")),
      );
    }

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
          'Chi Tiết Thông báo',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDetailRow(context, "Tiêu đề", notification.title, 0),
            _buildDetailRow(context, "Nội dung", notification.content, 1),
            _buildDetailRow(
              context,
              "Thời gian",
              _formatDate(notification.timeCreate),
              2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    int index,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColor.isDarkMode(context)
                ? Colors.grey.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: Text(label, style: TextStyle(fontSize: 14))),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: index == 1
                ? HtmlWidget(
                    value,
                    textStyle: TextStyle(
                      color: AppColor.textColor(context),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      color: AppColor.textColor(context),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    try {
      return DateFormat('HH:mm - dd/MM/yyyy').format(date);
    } catch (e) {
      return '';
    }
  }
}
