import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../providers/kesehatan_provider.dart';
import '../widgets/grafik_kesehatan_chart.dart';
import '../widgets/input_kondisi_sheet.dart';

/// Sub-tab: Kesehatan — Kesehatan Kandang card + Insight + Hasil Kunjungan + Grafik
class TabKesehatan extends ConsumerWidget {
  const TabKesehatan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(kesehatanStatsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPaddingH,
        AppSpacing.md,
        AppDimensions.screenPaddingH,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeaderRow(
            title: 'Kesehatan Kandang',
            onTambah: () => _showInputKondisiSheet(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          _HariIniCard(stats: stats),
          const SizedBox(height: AppSpacing.sm),
          const _InsightKesehatanCard(),
          const SizedBox(height: AppSpacing.sm),
          const _KunjunganPetugasCard(),
          const SizedBox(height: AppSpacing.sm),
          const _GrafikUtamaCard(),
        ],
      ),
    );
  }

  void _showInputKondisiSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (_) => const InputKondisiSheet(),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback onTambah;

  const _HeaderRow({required this.title, required this.onTambah});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.textDarker,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onTambah,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 2,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: AppColors.white, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    'Tambah',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HariIniCard extends StatelessWidget {
  final KesehatanStats stats;

  const _HariIniCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hari Ini',
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.textDarker,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.pets_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${stats.total}',
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  value: '${stats.persenSehat.toStringAsFixed(0)}%',
                  label: 'Sehat',
                  icon: Icons.favorite_rounded,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _StatBox(
                  value: '${stats.perluDicek}',
                  label: 'Perlu Dicek',
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _StatBox(
                  value: '${stats.sakit}',
                  label: 'Sakit',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () => context.push('/ternak/detail-kesehatan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
              child: Text(
                'Lihat Detail Kesehatan',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;

  const _StatBox({required this.value, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Column(
        children: [
          if (icon != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightKesehatanCard extends StatelessWidget {
  const _InsightKesehatanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insight Kesehatan',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.orange, size: 22),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Risiko Sedang: 17% terindikasi Flu, beri vitamin C '
                  'dan antibiotic ringan segera!',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textDark,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KunjunganPetugasCard extends StatelessWidget {
  const _KunjunganPetugasCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasil Kunjungan Petugas',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 14, color: AppColors.textDarker),
              const SizedBox(width: 4),
              Text(
                'Drh. Dwi Aisyah',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textDarker,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Icon(Icons.calendar_today_outlined,
                  size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                '24 Juni 2026',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const _LabeledBullets(
            label: 'Saran:',
            bullets: [
              'Lakukan penanganan kandang secara berkala.',
              'Gunakan disinfektan pada area penyimpanan pakan dan peralatan ternak.',
            ],
          ),
          const SizedBox(height: 6),
          const _LabeledBullets(
            label: 'Penyebab\nGejala:',
            bullets: [
              'Ternak mengalami penurunan nafsu makan.',
              'Terjadi kotoran encer / gangguan pencernaan.',
              'Sirkulasi udara yang kurang baik dan kualitas pakan yang menurun. '
                  'Disarankan untuk segera mengecek ventilasi kandang serta kualitas dan kebersihan pakan.',
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Builder(
            builder: (ctx) => SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () => ctx.push('/ternak/laporan-kunjungan'),
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      AppColors.creamMuted.withValues(alpha: 0.4),
                  foregroundColor: AppColors.textDarker,
                  side: const BorderSide(color: AppColors.creamMuted),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                child: Text(
                  'Lihat Laporan Disini',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledBullets extends StatelessWidget {
  final String label;
  final List<String> bullets;

  const _LabeledBullets({required this.label, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xs + 2),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bullets.map((b) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textDark,
                          fontSize: 11,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          b,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textDark,
                            fontSize: 11,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _GrafikUtamaCard extends ConsumerWidget {
  const _GrafikUtamaCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(grafikKesehatanProvider);
    final activeFilter = ref.watch(grafikFilterProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grafik Utama',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // ===== Filter pills — 4 pilihan horizontal scrollable =====
          _FilterPillsRow(activeFilter: activeFilter),
          const SizedBox(height: AppSpacing.sm),
          GrafikKesehatanChart(data: data, filter: activeFilter),
          const SizedBox(height: AppSpacing.sm),
          _LegendRow(activeFilter: activeFilter),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Catatan Grafik',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.orange, size: 22),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _catatanForFilter(activeFilter)
                      .map((text) => _CatatanBullet(text))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Catatan bullets yang relevan sesuai filter.
  List<String> _catatanForFilter(GrafikFilter filter) {
    switch (filter) {
      case GrafikFilter.semua:
        return const [
          'Suhu naik 2°C dalam 3 hari terakhir',
          'Kasus sakit meningkat 18%',
          'Disarankan cek ventilasi kandang',
        ];
      case GrafikFilter.suhu:
        return const [
          'Suhu naik 2°C dalam 3 hari terakhir',
          'Disarankan cek ventilasi kandang',
        ];
      case GrafikFilter.kasus:
        return const [
          'Kasus sakit meningkat 18%',
          'Segera lakukan pengecekan individu ternak',
        ];
      case GrafikFilter.mortalitas:
        return const [
          'Mortalitas menurun di periode terakhir',
          'Tetap monitor ternak kondisi lemah',
        ];
    }
  }
}

/// Row 4 pill filter yang bisa di-tap untuk ganti Grafik Utama.
/// Horizontal scrollable kalau kepanjangan di HP kecil.
class _FilterPillsRow extends ConsumerWidget {
  final GrafikFilter activeFilter;

  const _FilterPillsRow({required this.activeFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: GrafikFilter.values.map((filter) {
          final isActive = filter == activeFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                onTap: () =>
                    ref.read(grafikFilterProvider.notifier).state = filter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.white,
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.border,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.white
                              : AppColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        filter.label,
                        style: AppTypography.labelMedium.copyWith(
                          color: isActive
                              ? AppColors.white
                              : AppColors.textDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final GrafikFilter activeFilter;

  const _LegendRow({required this.activeFilter});

  @override
  Widget build(BuildContext context) {
    // Tentukan legend items yang tampil sesuai filter
    final items = <_LegendItem>[];
    if (activeFilter == GrafikFilter.semua ||
        activeFilter == GrafikFilter.suhu) {
      items.add(const _LegendItem(color: Color(0xFF7C9A6F), label: 'Suhu'));
    }
    if (activeFilter == GrafikFilter.semua ||
        activeFilter == GrafikFilter.kasus) {
      items.add(
          const _LegendItem(color: Color(0xFFE8B93C), label: 'Kasus Sakit'));
    }
    if (activeFilter == GrafikFilter.semua ||
        activeFilter == GrafikFilter.mortalitas) {
      items.add(
          const _LegendItem(color: Color(0xFFC95B4D), label: 'Mortalitas'));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          items[i],
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textDark,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatatanBullet extends StatelessWidget {
  final String text;

  const _CatatanBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textDark,
              fontSize: 11,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textDark,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
