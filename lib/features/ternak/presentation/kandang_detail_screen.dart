import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../providers/kandang_provider.dart';

/// Detail Kandang screen — foto kandang + info pill table + Lihat Detail Ternak button.
class KandangDetailScreen extends ConsumerWidget {
  final String kandangId;

  const KandangDetailScreen({super.key, required this.kandangId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kandang =
        ref.watch(kandangListProvider.notifier).getById(kandangId);

    if (kandang == null) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Column(
          children: [
            SandAppBar(
              title: 'Detail Kandang',
              onBackPressed: () => context.pop(),
            ),
            Expanded(
              child: Center(
                child: Text('Kandang tidak ditemukan',
                    style: AppTypography.bodyMedium),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Detail Kandang',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Detail Kandang',
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildCard(kandang),
                  const SizedBox(height: AppSpacing.lg),
                  _buildLihatDetailTernakButton(context, kandang.id),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Kandang k) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
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
          // Photo
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: k.fotoPath != null && File(k.fotoPath!).existsSync()
                  ? Image.file(File(k.fotoPath!), fit: BoxFit.cover)
                  : Container(
                      color: const Color(0xFF7C9A6F).withValues(alpha: 0.6),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.pets_rounded,
                        color: AppColors.white,
                        size: 60,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            k.nama,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          Text(
            k.jenis.label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PillRow(label: 'Jenis ternak', value: k.jenis.label),
          const SizedBox(height: 6),
          _PillRowPopulasi(
            label: 'Jumlah populasi',
            total: k.jumlahPopulasi,
            jantan: k.jumlahJantan,
            betina: k.jumlahBetina,
          ),
          const SizedBox(height: 6),
          _PillRow(label: 'Umur batch', value: k.umurBatch),
          const SizedBox(height: 6),
          _PillRow(label: 'Jumlah Awal', value: '${k.jumlahAwal}'),
          const SizedBox(height: 6),
          _PillRow(label: 'Jumlah Mati', value: '${k.jumlahMati}'),
          const SizedBox(height: 6),
          _PillRow(label: 'Jumlah Lahir', value: '${k.jumlahLahir}'),
          const SizedBox(height: 6),
          _PillRow(
            label: 'Status aktif',
            value: k.statusAktif ? 'Aktif' : 'Nonaktif',
          ),
        ],
      ),
    );
  }

  Widget _buildLihatDetailTernakButton(BuildContext context, String id) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => context.push('/ternak/kandang/$id/detail-ternak'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        child: Text(
          'Lihat Detail Ternak',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _PillRow extends StatelessWidget {
  final String label;
  final String value;

  const _PillRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: _PillBox(text: value),
        ),
      ],
    );
  }
}

class _PillRowPopulasi extends StatelessWidget {
  final String label;
  final int total;
  final int jantan;
  final int betina;

  const _PillRowPopulasi({
    required this.label,
    required this.total,
    required this.jantan,
    required this.betina,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: _PillBox(text: '$total'),
        ),
        const SizedBox(width: 4),
        Text('L',
            style: AppTypography.labelMedium.copyWith(
                fontSize: 11, color: AppColors.textDark)),
        const SizedBox(width: 4),
        SizedBox(
          width: 36,
          child: _PillBox(text: '$jantan'),
        ),
        const SizedBox(width: 4),
        Text('P',
            style: AppTypography.labelMedium.copyWith(
                fontSize: 11, color: AppColors.textDark)),
        const SizedBox(width: 4),
        SizedBox(
          width: 36,
          child: _PillBox(text: '$betina'),
        ),
      ],
    );
  }
}

class _PillBox extends StatelessWidget {
  final String text;

  const _PillBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textDarker,
          fontSize: 12,
        ),
      ),
    );
  }
}
