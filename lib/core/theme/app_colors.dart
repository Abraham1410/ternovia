import 'package:flutter/material.dart';

/// Color palette berdasarkan design Figma Ternovia
/// Diekstrak dari splash, dashboard, dan komponen utama
class AppColors {
  AppColors._();

  // Primary — Brown earthy tones (warna utama splash & header)
  static const Color primary = Color(0xFF6B3410);
  static const Color primaryDark = Color(0xFF4A2309);
  static const Color primaryLight = Color(0xFF8B4513);
  static const Color primarySoft = Color(0xFFB08060);

  // Secondary — Accent brown untuk tombol
  static const Color secondary = Color(0xFF8B5A3C);
  static const Color secondaryLight = Color(0xFFC39A7D);

  // Background — Cream / off-white (background utama app)
  static const Color background = Color(0xFFFDF5EE);
  static const Color backgroundAlt = Color(0xFFF5E9DD);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFAF0E6);

  // Text
  static const Color textPrimary = Color(0xFF2D1810);
  static const Color textSecondary = Color(0xFF5C4033);
  static const Color textTertiary = Color(0xFF8B7264);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFB0A090);

  // Status warna (dari dashboard & health indicator)
  static const Color success = Color(0xFF4A7C3A);
  static const Color successLight = Color(0xFFDCE7D3);
  static const Color warning = Color(0xFFD97B3C);
  static const Color warningLight = Color(0xFFFDE5D3);
  static const Color danger = Color(0xFFC44536);
  static const Color dangerLight = Color(0xFFF5D5D1);
  static const Color info = Color(0xFF4A6B8A);
  static const Color infoLight = Color(0xFFD3DEE7);

  // Card & container colors (dari dashboard cards)
  static const Color cardHealth = Color(0xFF5C6B3F);
  static const Color cardAlert = Color(0xFFC17B5C);
  static const Color cardInfo = Color(0xFF8B5A3C);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // Border & divider
  static const Color border = Color(0xFFE0D0C0);
  static const Color borderLight = Color(0xFFEDE0D0);
  static const Color divider = Color(0xFFE8D9C7);

  // Input field
  static const Color inputBackground = Color(0xFFFFFBF5);
  static const Color inputBorder = Color(0xFFD4B896);

  // Shadow
  static Color shadow = const Color(0xFF6B3410).withOpacity(0.08);
  static Color shadowDark = const Color(0xFF2D1810).withOpacity(0.15);

  // Overlay
  static Color overlay = const Color(0xFF000000).withOpacity(0.5);
  static Color overlayLight = const Color(0xFF000000).withOpacity(0.3);
}
