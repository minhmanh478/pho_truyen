import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final Color textColor;

  const CustomLabel({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: textColor,
      ),
    );
  }
}
