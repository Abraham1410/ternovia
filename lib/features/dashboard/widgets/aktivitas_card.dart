import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AktivitasItem {
  final IconData icon;
  final String? iconAsset;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final VoidCallback? onTap;

  const AktivitasItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconAsset,
    this.subtitleColor,
    this.onTap,
  });
}

/// Compact aktivitas list — match Figma style.
/// Title header di luar white card (di atas card putih item list).
/// Icon 32px, langsung di sebelah kiri text (tanpa bungkus box).
class AktivitasHariIniCard extends StatelessWidget {
  final List<AktivitasItem> items;
  final VoidCallback? onSeeAll;

  const AktivitasHariIniCard({
    super.key,
    required this.items,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header — DI LUAR card
        Padding(
          padding: const EdgeInsets.fromLTRB(4, AppSpacing.xs, 4, AppSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Cek Aktivitas Hari Ini!',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              if (onSeeAll != null)
                InkWell(
                  onTap: onSeeAll,
                  child: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                ),
            ],
          ),
        ),
        // Card putih berisi list items
        Container(
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
            children: List.generate(items.length, (i) {
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  _AktivitasRow(item: items[i]),
                  if (!isLast)
                    Container(
                      height: 1,
                      color: AppColors.divider,
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _AktivitasRow extends StatelessWidget {
  final AktivitasItem item;

  const _AktivitasRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              // Icon langsung (tanpa box), 32px
              SizedBox(
                width: 32,
                height: 32,
                child: item.iconAsset != null
                    ? Image.asset(
                        item.iconAsset!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            item.icon,
                            size: 28,
                            color: AppColors.textDarker,
                          );
                        },
                      )
                    : Icon(
                        item.icon,
                        size: 28,
                        color: AppColors.textDarker,
                      ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: item.subtitleColor ?? AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: item.subtitleColor != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
