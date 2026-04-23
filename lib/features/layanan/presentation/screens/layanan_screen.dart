import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class LayananScreen extends ConsumerWidget {
  const LayananScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Text('Layanan',
                    style: AppTypography.headingLarge
                        .copyWith(color: AppColors.textOnPrimary)),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search,
                          color: AppColors.textTertiary, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari layanan',
                            hintStyle: AppTypography.bodyMedium
                                .copyWith(color: AppColors.textHint),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                StaggeredList(
                  baseDelay: const Duration(milliseconds: 100),
                  children: const [
                    _LayananCard(
                      icon: Icons.description_outlined,
                      title: 'Pengajuan SKT',
                      subtitle: 'Uji legalitas kelompok',
                    ),
                    SizedBox(height: AppSpacing.sm),
                    _LayananCard(
                      icon: Icons.volunteer_activism_outlined,
                      title: 'Konfirmasi Bantuan',
                      subtitle: 'Konfirmasi bantuan ternak / alat',
                    ),
                    SizedBox(height: AppSpacing.sm),
                    _LayananCard(
                      icon: Icons.grass_outlined,
                      title: 'Pengajuan Sample Pakan',
                      subtitle: 'Cek kualitas pakan',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Riwayat Pengajuan Terakhir',
                    style: AppTypography.headingMedium),
                const SizedBox(height: AppSpacing.sm),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 400),
                  child: _RiwayatCard(
                    title: 'Pengajuan Sample Pakan',
                    subtitle: 'Pakan konsentrat sapi perah',
                    date: '02 Januari 2026',
                    status: 'Dianalisis Laboratorium',
                    statusColor: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LayananCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _LayananCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.backgroundAlt,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.labelLarge
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final Color statusColor;

  const _RiwayatCard({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.labelLarge
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.inventory_2_outlined,
                size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(subtitle,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.calendar_today_outlined,
                size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(date,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
          ]),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
