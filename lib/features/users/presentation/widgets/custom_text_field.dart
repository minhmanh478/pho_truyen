import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pho_truyen/core/constants/app_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool enabled;
  final Color? fillColor;
  final Color? textColor;
  final TextInputType? keyboardType;
  final int maxLines;
  final IconData? suffixIcon;
  final Color? borderColor;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.enabled = true,
    this.fillColor,
    this.textColor,
    this.keyboardType,
    this.maxLines = 1,
    this.suffixIcon,
    this.inputFormatters,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: fillColor ?? AppColor.gray100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey)
            : null,
      ),
    );
  }
}
