import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class DashboardProductionCard extends StatelessWidget {
  final String total;
  final String layak;
  final String tidakLayak;

  const DashboardProductionCard({
    super.key,
    required this.total,
    required this.layak,
    required this.tidakLayak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.water_drop, color: AppColors.info),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            total,
            style: AppTypography.headingLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Layak', layak, AppColors.success),
                const SizedBox(height: 2),
                _buildRow('Tidak Layak', tidakLayak, AppColors.danger),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color) {
    return Row(
      children: [
        Text(label, style: AppTypography.bodySmall),
        const Spacer(),
        Text(
          value,
          style: AppTypography.labelMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
