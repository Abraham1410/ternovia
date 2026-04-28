import 'package:flutter/material.dart';

/// Design tokens warna Ternovia — match dengan Figma screenshot.
class AppColors {
  AppColors._();

  // ======= PRIMARY BROWN SCALE =======
  /// Warna utama brand — extracted dari Figma
  static const Color primary = Color(0xFF7C4C2C);
  static const Color primaryDark = Color(0xFF5C3620);
  static const Color primaryLight = Color(0xFF9A6644);
  static const Color primaryAccent = Color(0xFF885A40);

  // ======= CREAM / BEIGE =======
  static const Color cream = Color(0xFFFBF3EB);
  static const Color creamDark = Color(0xFFFAF2E9);
  static const Color creamMuted = Color(0xFFE3D3BE);

  // ======= ACCENT =======
  static const Color accent = Color(0xFFD78958);
  static const Color accentSoft = Color(0xFFD38551);

  // ======= TEXT =======
  static const Color textDark = Color(0xFF382511);
  static const Color textDarker = Color(0xFF22110E);
  static const Color textOnPrimary = Color(0xFFFBF3EB);
  static const Color textMuted = Color(0xFF6B5643);

  // ======= SEMANTIC =======
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // ======= UTILITIES =======
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  static Color get overlayDark => primary.withValues(alpha: 0.85);

  static const Color border = Color(0xFFE0D4C8);
  static const Color divider = Color(0xFFE0D4C8);
  static const Color infoBg = Color(0xFFF4E8D8);

  // ======= CARD COLORS (Dashboard) =======
  /// Warna overlay untuk card "Ternak Sehat" — hijau olive dari Figma
  static const Color cardSehat = Color(0xFF5C7B4A);

  /// Warna overlay untuk card "Ternak Perlu Dicek" — red-brown dari Figma
  static const Color cardPerluCek = Color(0xFFB5593C);
}
