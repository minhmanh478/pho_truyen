import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_color.dart';
import '../../../../domain/entities/author_story_detail_entity.dart';

class StoryDetailBottomActions extends StatelessWidget {
  final List<StoryButton> buttons;
  final Function(String) onAction;

  const StoryDetailBottomActions({
    super.key,
    required this.buttons,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    if (buttons.isEmpty) return const SizedBox.shrink();

    final isDarkMode = AppColor.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: buttons.asMap().entries.map((entry) {
          final index = entry.key;
          final button = entry.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 8,
                right: index == buttons.length - 1 ? 0 : 8,
              ),
              child: ElevatedButton(
                onPressed: () => onAction(button.code),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  button.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
