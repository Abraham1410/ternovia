import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/dashboard_activity_item.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_production_card.dart';
import '../widgets/dashboard_stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: DashboardHeader(
                  userName: 'Jenoardi',
                  onNotificationTap: () => context.push('/notifikasi'),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Kelompok info
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: _KelompokCard(),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Stat cards
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 300),
                    child: DashboardStatCard(
                      icon: Icons.favorite,
                      title: '21 Ternak Sehat!',
                      subtitle: 'Lihat grafik kesehatan ternak disini',
                      backgroundColor: AppColors.cardHealth,
                      buttonLabel: 'Lihat Grafik',
                      onButtonTap: () {},
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  FadeSlideIn(
                    delay: const Duration(milliseconds: 400),
                    child: DashboardStatCard(
                      icon: Icons.warning_amber_rounded,
                      title: '3 Ternak Perlu Dicek',
                      subtitle:
                          'Ternak alami sakit, pastikan beri penanganan yang tepat',
                      backgroundColor: AppColors.cardAlert,
                      buttonLabel: 'Cek Sekarang',
                      onButtonTap: () {},
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Produksi Hari Ini section
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      'Produksi Hari Ini',
                      style: AppTypography.headingMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  FadeSlideIn(
                    delay: const Duration(milliseconds: 600),
                    child: const DashboardProductionCard(
                      total: '24,6 Lt',
                      layak: '20 Lt',
                      tidakLayak: '4,6 Lt',
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Aktivitas Hari Ini
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 700),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cek Aktivitas Hari Ini!',
                            style: AppTypography.headingMedium),
                        Icon(Icons.chevron_right, color: AppColors.primary),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  StaggeredList(
                    baseDelay: const Duration(milliseconds: 800),
                    children: const [
                      DashboardActivityItem(
                        icon: Icons.vaccines,
                        title: 'Vaksinasi Ternak',
                        subtitle: 'Pukul 10.00',
                        iconColor: AppColors.danger,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      DashboardActivityItem(
                        icon: Icons.task_alt,
                        title: 'Konfirmasi Bantuan',
                        subtitle: 'Segera lakukan konfirmasi',
                        iconColor: AppColors.warning,
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KelompokCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.group, color: AppColors.success, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelompok Ternak Sukses Makmur',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '24 Ternak',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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
