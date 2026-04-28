import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Info panel — background cream dengan icon info.
///
/// Dipakai di atas form untuk kasih guidance ke user.
/// Contoh di Figma:
/// "Lengkapi data berikut untuk memulai pengelolaan kelompok di Ternovia."
class InfoPanel extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const InfoPanel({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textDark,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
