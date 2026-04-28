import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// "Produksi Hari Ini" — compact card match Figma.
class ProduksiCard extends StatelessWidget {
  final double totalLiter;
  final double layakLiter;
  final double tidakLayakLiter;

  const ProduksiCard({
    super.key,
    required this.totalLiter,
    required this.layakLiter,
    required this.tidakLayakLiter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer padding naik 15% dari sm (12) → 14 sesuai request "besarin 15%"
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
            child: Text(
              'Produksi Hari Ini',
              // Title 15 → 17 (+15%)
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.textDarker,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
          Container(
            // Box padding vertical 6 → 10 (+15% kompound dari request lama)
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              // Cream lebih nampol sesuai permintaan: #F0E3C4
              color: const Color(0xFFF0E3C4),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                _buildMilkIcon(),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${_formatLiter(totalLiter)} ',
                  // Angka utama 20 → 23 (+15%)
                  style: AppTypography.headingMedium.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 23,
                  ),
                ),
                Text(
                  'Lt',
                  // Unit 11 → 13 (+15%)
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textDarker,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Spacer lebih balanced — push kolom Layak/Tidak Layak
                // ke arah kanan tapi tetap ada margin dari edge
                const Spacer(),
                _buildStatColumn(
                  label: 'Layak',
                  value: '${_formatLiter(layakLiter)} Lt',
                  color: const Color(0xFF6A7344),
                ),
                // Gap antar 2 kolom — sm (12) → 18 biar lebih jelas terpisah
                // sesuai design Figma
                const SizedBox(width: 18),
                _buildStatColumn(
                  label: 'Tidak Layak',
                  value: '${_formatLiter(tidakLayakLiter)} Lt',
                  color: const Color(0xFFC4533A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilkIcon() {
    return SizedBox(
      // Icon 40 → 46 (+15%)
      width: 46,
      height: 46,
      child: Image.asset(
        AppConstants.iconHasilProduksi,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.local_drink_rounded,
            size: 36,
            color: AppColors.primary,
          );
        },
      ),
    );
  }

  Widget _buildStatColumn({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      // ⚠️ ALIGNMENT KOLOM LAYAK/TIDAK LAYAK ⚠️
      // CrossAxisAlignment.start = rata kiri (Figma match)
      // CrossAxisAlignment.end   = rata kanan (default sebelumnya)
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          // ⚠️ FONT LABEL "Layak"/"Tidak Layak" ⚠️
          // Naikkan kalo masih kekecilan (rekomendasi 12-14)
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
        ),
        Text(
          // ⚠️ FONT NUMBER "20 Lt" / "4,6 Lt" ⚠️
          // Naikkan kalo masih kekecilan (rekomendasi 16-20)
          value,
          style: AppTypography.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  String _formatLiter(double value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }
}
