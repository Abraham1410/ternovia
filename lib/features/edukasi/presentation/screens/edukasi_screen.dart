import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class EdukasiScreen extends ConsumerWidget {
  const EdukasiScreen({super.key});

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Edukasi',
                        style: AppTypography.headingLarge
                            .copyWith(color: AppColors.textOnPrimary)),
                    const Spacer(),
                    const Icon(Icons.bookmark_border,
                        color: AppColors.textOnPrimary),
                  ],
                ),
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
                            hintText: 'Cari artikel, video, atau tips peternakan',
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
                FadeSlideIn(
                  child: Text(
                    'Perpustakaan Materi Edukasi',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: Text('Materi Terbaru', style: AppTypography.headingMedium),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 200),
                        child: _MaterialCard(
                          title: 'Panduan Menjaga Kesehatan Sapi Perah',
                          label: 'Artikel & Tips',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 300),
                        child: _MaterialCard(
                          title: 'Tips Mengurangi Penyakit pada Ternak',
                          label: 'Video • 15 Menit',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 400),
                  child: Text('Materi Populer', style: AppTypography.headingMedium),
                ),
                const SizedBox(height: AppSpacing.sm),
                StaggeredList(
                  baseDelay: const Duration(milliseconds: 500),
                  children: const [
                    _ArticleItem(
                      title: 'Kesalahan Umum dalam Pemberian Pakan',
                      label: 'Artikel & Tips',
                    ),
                    SizedBox(height: AppSpacing.sm),
                    _ArticleItem(
                      title: 'Cara Cek Kondisi Ternak Tanpa Alat Khusus',
                      label: 'Artikel & Tips',
                    ),
                    SizedBox(height: AppSpacing.sm),
                    _ArticleItem(
                      title: 'Mengenali Tanda Awal Ternak Sakit',
                      label: 'Video • 13 Menit',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final String title;
  final String label;

  const _MaterialCard({required this.title, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundAlt,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(Icons.image_outlined,
                  color: AppColors.primarySoft, size: 40),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium
                .copyWith(fontWeight: FontWeight.w600),
          ),
          Text(label,
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ArticleItem extends StatelessWidget {
  final String title;
  final String label;

  const _ArticleItem({required this.title, required this.label});

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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.backgroundAlt,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.image_outlined,
                color: AppColors.primarySoft),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.labelMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(label,
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
