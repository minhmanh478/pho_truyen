import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  final String? imagePath;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onPress;

  const AuthWidget({
    super.key,
    this.imagePath,

    required this.label,
    required this.color,
    required this.textColor,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null) ...[
              Image.asset(imagePath!, height: 22, width: 22),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
