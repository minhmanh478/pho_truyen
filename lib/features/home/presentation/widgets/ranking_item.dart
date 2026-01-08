// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/features/story/presentation/pages/comic/comic_detail_page.dart';

//DATA MODEL
class RankingItem {
  final int id;
  final String title;
  final int score;
  final String imageUrl;

  RankingItem({
    required this.id,
    required this.title,
    required this.score,
    required this.imageUrl,
  });
}

class TopUnlockWidget extends StatelessWidget {
  final String title;
  final List<RankingItem> items;
  final double width;
  final String iconPath;

  const TopUnlockWidget({
    super.key,
    required this.title,
    required this.items,
    this.width = 320,
    required this.iconPath,
  });

  void _navigateToComicDetail(RankingItem item) {
    Get.to(() => const ComicDetailPage(), arguments: item.id);
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final cardBackgroundColor = isDarkMode
        ? const Color(0xFF1F2235)
        : Colors.white;
    final primaryTextColor = isDarkMode
        ? Colors.white
        : const Color(0xFF2C3E50);
    final secondaryTextColor = isDarkMode
        ? Colors.white70
        : const Color(0xFF546E7A);
    final dividerColor = isDarkMode ? Colors.white10 : const Color(0xFFF1F2F6);
    final borderColor = isDarkMode ? Colors.transparent : Colors.grey.shade100;

    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  color: primaryTextColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: primaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: dividerColor, thickness: 1),
          const SizedBox(height: 12),

          // 2. TOP 1
          _buildTop1Item(items[0], primaryTextColor),

          const SizedBox(height: 8),

          ...List.generate(items.length - 1, (index) {
            return _buildListItem(
              items[index + 1],
              index + 2,
              primaryTextColor,
              secondaryTextColor,
            );
          }),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTop1Item(RankingItem item, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToComicDetail(item),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _MedalBadge(rank: 1, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildPriceTag(item.score, isLarge: true),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          GestureDetector(
            onTap: () => _navigateToComicDetail(item),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 70,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    Container(width: 70, height: 100, color: Colors.grey[800]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //LIST ITEMS
  Widget _buildListItem(
    RankingItem item,
    int rank,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return GestureDetector(
      onTap: () => _navigateToComicDetail(item),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: rank <= 3
                  ? _MedalBadge(rank: rank, size: 22)
                  : Center(
                      child: Text(
                        "$rank",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            _buildPriceTag(item.score, isLarge: false),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTag(int score, {bool isLarge = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatNumber(score),
          style: TextStyle(
            fontSize: isLarge ? 15 : 12,
            fontWeight: isLarge ? FontWeight.w700 : FontWeight.w600,
            color: const Color(0xFFFF6F00),
          ),
        ),
        const SizedBox(width: 6),
        Image.asset(iconPath, height: 13),
      ],
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class _MedalBadge extends StatelessWidget {
  final int rank;
  final double size;
  const _MedalBadge({required this.rank, this.size = 36});
  @override
  Widget build(BuildContext context) {
    Color color = rank == 1
        ? const Color(0xFFFFD700)
        : (rank == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32));
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.emoji_events, color: Colors.white, size: size * 0.6),
      ),
    );
  }
}
