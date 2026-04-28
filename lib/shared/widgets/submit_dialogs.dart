import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Pop-up konfirmasi sebelum submit pengajuan SKT.
/// Sesuai design Figma (Pop_Up_Konfirmasi.png):
/// - Close X di kanan atas
/// - Ilustrasi petani + sapi di tengah
/// - "Apakah data sudah benar?"
/// - Subtitle: "Setelah dikirim, pengajuan akan diverifikasi oleh petugas."
/// - Button "Ya" besar coklat
class SubmitConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const SubmitConfirmDialog({
    super.key,
    required this.onConfirm,
  });

  /// Show dialog — return true kalau user tap "Ya", false/null kalau dismiss.
  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => SubmitConfirmDialog(
        onConfirm: () => Navigator.of(ctx).pop(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close X di kanan atas
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              // Ilustrasi gabung_kelompok.png (v30.2: update sesuai permintaan)
              _buildIllustration(),
              const SizedBox(height: AppSpacing.md),
              // Title
              Text(
                'Apakah data sudah benar?',
                textAlign: TextAlign.center,
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textDarker,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              // Subtitle
              Text(
                'Setelah dikirim, pengajuan akan diverifikasi oleh petugas.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Button Ya — besar coklat full width
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  child: Text(
                    'Ya',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      // v30.3: User request besarkan 50% (120 → 180) karena di Figma kelihatan
      // dominan sebagai hero visual di tengah dialog.
      width: 180,
      height: 180,
      child: Image.asset(
        AppConstants.ilustrasiKonfirmasi,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Placeholder kalau asset belum ada
          return Container(
            decoration: BoxDecoration(
              color: AppColors.cream,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: const Icon(
              Icons.groups_rounded,
              size: 56,
              color: AppColors.primary,
            ),
          );
        },
      ),
    );
  }
}

/// Pop-up berhasil setelah submit pengajuan SKT.
/// Sesuai design Figma (Pop_Up_Berhasil_Melakukan_Pengajuan.png):
/// - Close X di kanan atas
/// - Ilustrasi confetti + checkmark coklat
/// - "🎉 Berhasil Melakukan Pengajuan!"
/// - Subtitle: "Jangan lupa untuk cek pengajuan kamu secara berkala"
class SubmitSuccessDialog extends StatelessWidget {
  final VoidCallback? onClose;

  const SubmitSuccessDialog({
    super.key,
    this.onClose,
  });

  /// Show dialog — auto-close dalam 2.5 detik atau tap X.
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onClosed,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SubmitSuccessDialog(
        onClose: () {
          Navigator.of(ctx).pop();
          onClosed?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close X
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textMuted,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // Ilustrasi confetti + checkmark
            _buildIllustration(),
            const SizedBox(height: AppSpacing.md),
            // Title with emoji
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Berhasil Melakukan Pengajuan!',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            // Subtitle
            Text(
              'Jangan lupa untuk cek pengajuan\nkamu secara berkala',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      // v30.4: User request gedein lagi (120 → 220)
      width: 220,
      height: 220,
      child: Image.asset(
        AppConstants.ilustrasiBerhasil,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Placeholder kalau asset belum ada —
          // lingkaran coklat dengan checkmark + confetti dots
          return Stack(
            alignment: Alignment.center,
            children: [
              // Confetti dots
              ...List.generate(8, (i) {
                final angle = (i * 45.0) * math.pi / 180;
                return Positioned(
                  left: 60 + 48 * math.cos(angle) - 3,
                  top: 60 + 48 * math.sin(angle) - 3,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i.isEven
                          ? AppColors.primary
                          : AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
              // Center checkmark circle
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.white,
                  size: 40,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
