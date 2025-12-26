import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  final Color textColor;
  final Color secondaryTextColor;
  final Color cardBgColor;
  final bool isDarkMode;

  final String? trailingText;
  final Widget? trailingWidget;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardBgColor,
    this.isDarkMode = false,
    this.onTap,
    this.trailingText,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: isDarkMode ? Border.all(color: Colors.white10) : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                //Leading Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.shade300.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: textColor, size: 20),
                ),
                const SizedBox(width: 16),
                //Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                //Trailing
                _buildTrailing(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing() {
    if (trailingWidget != null) {
      return trailingWidget!;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trailingText != null) ...[
          Text(
            trailingText!,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (onTap != null) const SizedBox(width: 8),
        ],
        if (onTap != null)
          Icon(Icons.chevron_right, color: secondaryTextColor, size: 20),
      ],
    );
  }
}
