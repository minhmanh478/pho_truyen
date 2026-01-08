// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pho_truyen/core/router/app_routes.dart';
import '../../domain/entities/notification_entity.dart';
import '../controllers/notification_controller.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final Color textColor;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    final isRead = notification.isRead;
    final titleStyle = TextStyle(
      color: textColor,
      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
      fontSize: 16,
    );
    final contentStyle = TextStyle(
      color: isRead ? textColor.withOpacity(0.6) : textColor.withOpacity(0.9),
      fontSize: 14,
    );

    return Slidable(
      key: Key(notification.id.toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) {
              controller.deleteNotification(notification.id!);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            controller.readNotification(notification.id!);
          }
          Get.toNamed(AppRoutes.notificationDetail, arguments: notification);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.image.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: notification.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(notification.title, style: titleStyle),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text.rich(
                      TextSpan(
                        children: _parseHtml(
                          notification.content,
                          contentStyle,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(notification.timeCreate),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: isRead
                            ? FontWeight.normal
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  List<InlineSpan> _parseHtml(String text, TextStyle style) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'<b>(.*?)<\/b>');
    int start = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(
          TextSpan(text: text.substring(start, match.start), style: style),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: style.copyWith(fontWeight: FontWeight.bold),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }
    return spans;
  }
}
