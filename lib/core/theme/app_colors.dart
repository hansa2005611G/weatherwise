import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryDark = Color(0xFF2E5C8A);
  static const Color primaryLight = Color(0xFF87CEEB);

  // Secondary Colors
  static const Color secondary = Color(0xFF50C878);
  static const Color secondaryDark = Color(0xFF2E7D4E);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);

  // Weather Condition Colors
  static const Color sunny = Color(0xFFFDB813);
  static const Color cloudy = Color(0xFF9E9E9E);
  static const Color rainy = Color(0xFF5C9EAD);
  static const Color stormy = Color(0xFF4A5568);
  static const Color snowy = Color(0xFFE8F4F8);
  static const Color foggy = Color(0xFFBDBDBD);

  // Functional Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient Colors
  static const List<Color> sunnyGradient = [
    Color(0xFFFDB813),
    Color(0xFFFFD54F),
  ];

  static const List<Color> rainyGradient = [
    Color(0xFF5C9EAD),
    Color(0xFF89CFF0),
  ];

  static const List<Color> cloudyGradient = [
    Color(0xFF9E9E9E),
    Color(0xFFBDBDBD),
  ];

  static const List<Color> nightGradient = [
    Color(0xFF2C3E50),
    Color(0xFF34495E),
  ];
}