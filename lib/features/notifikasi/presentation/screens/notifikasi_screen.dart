import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          FadeSlideIn(
            child: Text('Hari Ini',
                style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textSecondary)),
          ),
          const SizedBox(height: AppSpacing.sm),
          StaggeredList(
            baseDelay: const Duration(milliseconds: 100),
            children: const [
              _NotifItem(
                title: 'Hasil pemeriksaan sampel pakan keluar!',
                time: '5 menit lalu',
              ),
              SizedBox(height: AppSpacing.sm),
              _NotifItem(
                title: 'Produksi susu berhasil dicatat',
                time: '1 jam lalu',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FadeSlideIn(
            delay: const Duration(milliseconds: 300),
            child: Text('Kemarin',
                style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textSecondary)),
          ),
          const SizedBox(height: AppSpacing.sm),
          StaggeredList(
            baseDelay: const Duration(milliseconds: 400),
            children: const [
              _NotifItem(
                title: '3 ternak dijadwalkan vaksin hari ini',
                time: 'Kemarin, 18.20',
              ),
              SizedBox(height: AppSpacing.sm),
              _NotifItem(
                title: 'Produksi susu berhasil dicatat',
                time: 'Kemarin, 14.05',
              ),
              SizedBox(height: AppSpacing.sm),
              _NotifItem(
                title: 'Kelompok Sapi Makmur berhasil dibuat',
                time: 'Kemarin, 10.42',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final String title;
  final String time;

  const _NotifItem({required this.title, required this.time});

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
            child: const Icon(Icons.campaign_outlined,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.labelMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(time,
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
