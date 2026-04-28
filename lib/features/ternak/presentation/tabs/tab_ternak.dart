import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../providers/kandang_provider.dart';

/// Sub-tab: Ternak — list kandang cards.
class TabTernak extends ConsumerWidget {
  const TabTernak({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kandangList = ref.watch(kandangFilteredProvider);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Data Kandang',
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.textDarker,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              _TambahPill(
                onTap: () => context.push('/ternak/tambah-kandang'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (kandangList.isEmpty)
            _buildEmpty(context)
          else
            ...kandangList.map((k) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: _KandangCard(
                    kandang: k,
                    onTap: () => context.push('/ternak/kandang/${k.id}'),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.house_outlined,
            size: 60,
            color: AppColors.textMuted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Belum ada kandang',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          Text(
            'Tap "+ Tambah" untuk menambah kandang baru',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TambahPill extends StatelessWidget {
  final VoidCallback onTap;

  const _TambahPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
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
    );
  }
}

class _KandangCard extends StatelessWidget {
  final Kandang kandang;
  final VoidCallback onTap;

  const _KandangCard({required this.kandang, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs + 2),
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
          child: Row(
            children: [
              _buildThumbnail(),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      kandang.nama,
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      kandang.jenis.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (kandang.produksiLiter != null) ...[
                Text(
                  '${kandang.produksiLiter!.toStringAsFixed(1)} L',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      clipBehavior: Clip.antiAlias,
      child: kandang.fotoPath != null && File(kandang.fotoPath!).existsSync()
          ? Image.file(File(kandang.fotoPath!), fit: BoxFit.cover)
          : _fallbackThumbnail(),
    );
  }

  Widget _fallbackThumbnail() {
    // Default icon kandang (green-ish background with sapi icon)
    return Container(
      color: const Color(0xFF7C9A6F).withValues(alpha: 0.6),
      alignment: Alignment.center,
      child: const Icon(
        Icons.pets_rounded,
        color: AppColors.white,
        size: 28,
      ),
    );
  }
}
