import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system berdasarkan design Figma Ternovia
/// Font utama: Poppins (fallback ke Google Fonts bila asset belum ada)
class AppTypography {
  AppTypography._();

  static TextStyle get _base => GoogleFonts.poppins(
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // Display — untuk heading besar seperti "Selamat Datang!"
  static TextStyle displayLarge = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle displayMedium = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle displaySmall = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // Heading — section title seperti "Produksi Hari Ini", "Dashboard"
  static TextStyle headingLarge = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headingMedium = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headingSmall = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Body
  static TextStyle bodyLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Label
  static TextStyle labelLarge = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelMedium = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  // Button
  static TextStyle buttonLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  static TextStyle buttonMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  // Special — logo text "TERNOVIA"
  static TextStyle logoText = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 2,
  );
}
