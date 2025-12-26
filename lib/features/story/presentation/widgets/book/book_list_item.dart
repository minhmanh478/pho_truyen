import 'package:flutter/material.dart';
import 'package:pho_truyen/core/constants/app_color.dart';

class BookListItem extends StatelessWidget {
  final dynamic item;

  const BookListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : AppColor.slate900;
    final Color subColor = isDarkMode ? Colors.white70 : AppColor.slate600;
    final Color bgCardColor = isDarkMode
        ? const Color(0xFF1F2235)
        : Colors.white;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: bgCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Image.network(
              item.imageUrl,
              width: 70,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) =>
                  Container(color: Colors.grey[800], width: 70),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.author,
                    style: TextStyle(color: subColor, fontSize: 13),
                    maxLines: 1,
                  ),
                  Text(
                    "Đang đọc: Chap 120",
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF4C8EF9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: subColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
