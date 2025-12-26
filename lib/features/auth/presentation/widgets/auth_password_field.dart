import 'package:flutter/material.dart';
import 'package:pho_truyen/core/constants/app_color.dart';

class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isHidden;
  final VoidCallback onToggle;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.isHidden,
    required this.onToggle,
    required this.hintText,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isHidden,
        style: const TextStyle(color: Colors.white),
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(
            prefixIcon ?? Icons.lock_outline,
            color: Colors.grey.shade500,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isHidden ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade500,
            ),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
