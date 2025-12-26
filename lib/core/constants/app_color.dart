import 'package:flutter/material.dart';

class AppColor {
  // Black & White
  static const Color blackPrimary = Color(0xFF000000);
  static const Color backgroupPrimary = Color(0x0fffffff);
  static const Color whitePrimary = Color(0xFFFFFFFF);

  //
  static const Color darkIndigoGray = Color(0xFF2E3A4E);
  static const Color navyGray = Color(0xFF2F3E50);

  // Primary Colors
  static const Color primary = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF5472D3);
  static const Color primaryDark = Color(0xFF002171);

  // Grays
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF9F9F9);
  static const Color backgroundDark = Color(0xFF121212);

  // Transparent
  static const Color transparent = Colors.transparent;

  static Color cardColor = Color(0xFF1E293B);
  static Color primaryColor = Color(0xFF2563EB);
  static Color backgroundLight1 = Color(0xFFf7f6f8);
  static Color backgroundDark1 = Color(0xFF191022);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate600 = Color(0xFF475569);

  static Color? get primaryBlue => null;

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color textColor(BuildContext context) {
    final isDark = isDarkMode(context);
    return isDark ? Colors.white : slate900;
  }

  static Color secondaryTextColor(BuildContext context) {
    final isDark = isDarkMode(context);
    return isDark ? Colors.grey.shade400 : slate600;
  }

  static Color inputFillColor(BuildContext context) {
    final isDark = isDarkMode(context);
    return isDark ? Colors.grey.shade800 : gray100;
  }
}
