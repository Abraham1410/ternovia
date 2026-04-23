import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Jadwal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          FadeSlideIn(child: _CalendarStrip()),
          const SizedBox(height: AppSpacing.xl),
          FadeSlideIn(
            delay: const Duration(milliseconds: 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jadwal Hari Ini', style: AppTypography.headingMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    '+ Tambah Jadwal',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          StaggeredList(
            baseDelay: const Duration(milliseconds: 300),
            children: const [
              _JadwalItem(
                title: 'Pertemuan Kelompok',
                subtitle: 'Membahas pembagian bantuan dinas',
              ),
              SizedBox(height: AppSpacing.sm),
              _JadwalItem(
                title: 'Vaksin Ternak PMK',
                subtitle: 'Perlu dilakukan vaksin hari ini',
              ),
              SizedBox(height: AppSpacing.sm),
              _JadwalItem(
                title: 'Kunjungan Lapangan',
                subtitle: 'Monitoring kondisi kandang dan ternak',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FadeSlideIn(
            delay: const Duration(milliseconds: 600),
            child: Text('Jadwal Satu Minggu', style: AppTypography.headingMedium),
          ),
          const SizedBox(height: AppSpacing.md),
          StaggeredList(
            baseDelay: const Duration(milliseconds: 700),
            children: const [
              _JadwalItem(
                title: 'Pelatihan Peternak',
                subtitle: 'Pelatihan pengelolaan produksi ternak',
              ),
              SizedBox(height: AppSpacing.sm),
              _JadwalItem(
                title: 'Kunjungan Lapangan',
                subtitle: 'Monitoring kondisi kandang dan ternak',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum'];
    final dates = [12, 13, 14, 15, 16];
    const activeIndex = 0;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Text('Februari', style: AppTypography.labelLarge),
          const SizedBox(height: 2),
          Text('Jadwal Hari Ini - Senin, 12 Januari',
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(days.length, (i) {
              final isActive = i == activeIndex;
              return Column(
                children: [
                  Text(days[i],
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.backgroundAlt,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${dates[i]}',
                      style: AppTypography.labelMedium.copyWith(
                        color: isActive
                            ? AppColors.textOnPrimary
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _JadwalItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _JadwalItem({required this.title, required this.subtitle});

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
            child: const Icon(Icons.pets, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.labelMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
