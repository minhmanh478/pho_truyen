import 'package:flutter/material.dart';

class MangaCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double width;
  final double imageHeight;
  final VoidCallback? onTap;

  const MangaCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.width,
    this.imageHeight = 175.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //1Phần Ảnh bìa (đã được tách ra)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: width,
                height: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: width,
                  height: imageHeight,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              ),
            ),

            const SizedBox(height: 8),

            //2 Phần Tên truyện
            Text(
              title.isNotEmpty ? title : 'Chưa cập nhật',
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // Thêm "..." nếu quá dài
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            // 3. Phần Tác giả
            if (author.isNotEmpty && author != 'Unknown')
              Text(
                author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
