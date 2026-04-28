import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Compact stat card — match Figma:
/// - Icon container 40x40 (bukan 48)
/// - Title single line, fontSize 17
/// - Subtitle fontSize 11, max 2 lines
/// - Padding 12px (AppSpacing.sm)
/// - Button compact padding
/// - [height]: tinggi card explicit agar card hijau & merah identik
class DashboardStatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback? onCtaTap;

  final String? backgroundImage;
  final Alignment imageAlignment;
  final Color overlayColor;

  final String? iconAsset;
  final IconData fallbackIcon;

  final Color? ctaBackgroundColor;
  final Color? ctaTextColor;

  /// Tinggi card (dulu 82, sekarang 95 ≈ +15% sesuai request user).
  final double height;

  /// Border radius card. Default 14 (Figma-match, sebelumnya 20 yang terlalu pill-shaped)
  final double borderRadius;

  /// Scale factor untuk background image (zoom in).
  /// 1.0 = original, 1.5 = zoom 50%, 2.0 = zoom 100%, dst.
  /// Pakai bareng [imageAlignment] untuk fokus ke bagian tertentu (misal sapi).
  final double imageScale;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.overlayColor,
    required this.fallbackIcon,
    this.onCtaTap,
    this.backgroundImage,
    this.imageAlignment = Alignment.center,
    this.iconAsset,
    this.ctaBackgroundColor,
    this.ctaTextColor,
    this.height = 95,
    this.borderRadius = 14,
    this.imageScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            if (backgroundImage != null)
              Positioned.fill(
                // Transform.scale → zoom in gambar sapi biar lebih jelas
                // ClipRRect parent sudah cukup untuk clip overflow (gak butuh
                // ClipRect lagi karena udah di-wrap)
                child: Transform.scale(
                  scale: imageScale,
                  alignment: imageAlignment,
                  child: Image.asset(
                    backgroundImage!,
                    fit: BoxFit.cover,
                    alignment: imageAlignment,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: overlayColor);
                    },
                  ),
                ),
              ),
          Positioned.fill(
            child: Container(
              color: overlayColor.withValues(alpha: 0.6),
            ),
          ),
          // Compact padding — 12px all sides
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIconContainer(),
                const SizedBox(width: AppSpacing.sm),
                // Title + subtitle column (kiri)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        // Title 17 → 18 (sedikit lebih besar match Figma)
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        // Subtitle 11 → 13 (naik biar lebih kebaca)
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.white.withValues(alpha: 0.95),
                          fontSize: 15,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Gap antara text column dan CTA pill
                const SizedBox(width: AppSpacing.sm),
                // CTA pill di kanan, vertical center (Figma layout)
                _buildCta(),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    // Icon tanpa box background — langsung render 40x40 sesuai Figma.
    // Icon PNG-nya full-bleed mengisi slot.
    return SizedBox(
      width: 40,
      height: 40,
      child: iconAsset != null
          ? Image.asset(
              iconAsset!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(fallbackIcon,
                    color: AppColors.white, size: 32);
              },
            )
          : Icon(fallbackIcon, color: AppColors.white, size: 32),
    );
  }

  Widget _buildCta() {
    // Default Figma: cream bg + brown text. User bisa override pake
    // ctaBackgroundColor / ctaTextColor kalo butuh.
    final bgColor = ctaBackgroundColor ?? AppColors.cream;
    final fgColor = ctaTextColor ?? AppColors.primary;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onCtaTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 2,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.button),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            ctaLabel,
            style: AppTypography.labelMedium.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
