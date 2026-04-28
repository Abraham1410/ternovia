import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/ternovia_logo.dart';

/// KelompokBerhasilScreen — tampil setelah Ketua berhasil Buat Kelompok.
///
/// Sesuai design Figma:
/// - Background cream
/// - Header: logo Ternovia + badge Dinas
/// - Ilustrasi undangan.png (farmer + sapi) — size besar, center
/// - Title "Kelompok Berhasil Dibuat!" (dark)
/// - Subtitle 3 baris (muted)
/// - Undang Anggota (primary coklat) / Lewati (outline cream)
class KelompokBerhasilScreen extends ConsumerWidget {
  final String? kodeUndangan;

  const KelompokBerhasilScreen({super.key, this.kodeUndangan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIllustration(),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Kelompok Berhasil Dibuat!',
                      textAlign: TextAlign.center,
                      style: AppTypography.headingLarge.copyWith(
                        color: AppColors.textDarker,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Undang anggota kelompokmu sekarang\ndan mulai bangun ekosistem ternak yang\nlebih modern.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                label: 'Undang Anggota',
                onPressed: () {
                  final code = kodeUndangan ?? _generateSampleCode();
                  context.go('/bagikan-kode?kode=$code');
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'Lewati',
                onPressed: () => context.go('/dashboard'),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: -AppSpacing.xs,
            top: AppSpacing.xs,
            child: IconButton(
              onPressed: () => context.go('/dashboard'),
              icon: const Icon(
                Icons.chevron_left,
                color: AppColors.textDark,
                size: 28,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xs),
                TernoviaLogoWithText(
                  iconSize: 36,
                  textStyle: AppTypography.headingXL.copyWith(
                    color: AppColors.primary,
                    fontSize: 22,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const DinasLogo(size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppConstants.organizationName,
                      style: AppTypography.captionOnPrimary.copyWith(
                        color: AppColors.textDark,
                      ),
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

  /// Ilustrasi farmer + sapi dari asset undangan.png.
  /// Sesuai design Figma, gak ada circle border — langsung image.
  Widget _buildIllustration() {
    return Image.asset(
      AppConstants.undanganIllustration,
      width: 280,
      height: 280,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback kalau file belum ada atau path salah
        return Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            color: AppColors.infoBg.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.broken_image_outlined,
            size: 80,
            color: AppColors.textMuted,
          ),
        );
      },
    );
  }

  String _generateSampleCode() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final suffix = (now % 100000).toString().padLeft(5, '0');
    return 'TN-$suffix';
  }
}
