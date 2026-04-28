import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/info_panel.dart';
import '../../../shared/widgets/primary_button.dart';

class GabungKelompokForm extends ConsumerStatefulWidget {
  const GabungKelompokForm({super.key});

  @override
  ConsumerState<GabungKelompokForm> createState() =>
      _GabungKelompokFormState();
}

class _GabungKelompokFormState extends ConsumerState<GabungKelompokForm> {
  final _namaController = TextEditingController();
  final _kodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _kodeController.dispose();
    super.dispose();
  }

  void _handleGabung() {
    if (_namaController.text.trim().isEmpty ||
        _kodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Nama dan kode undangan tidak boleh kosong'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi API call
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _BerhasilGabungDialog(
          onLanjut: () {
            Navigator.of(ctx).pop();
            _namaController.clear();
            _kodeController.clear();
            context.go('/dashboard');
          },
          onClose: () => Navigator.of(ctx).pop(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoPanel(
            message:
                'Masukkan kode undangan dari ketua kelompok agar data ternak dan aktivitasmu bisa dikelola bersama.',
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildIllustrationPlaceholder(),
          const SizedBox(height: AppSpacing.xl),
          _buildFormCard(),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Gabung Kelompok',
            onPressed: _handleGabung,
            isLoading: _isLoading,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildBottomHint(),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildIllustrationPlaceholder() {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Image.asset(
          AppConstants.gabungKelompokIllustration,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback kalau asset belum ada
            return Container(
              decoration: BoxDecoration(
                color: AppColors.infoBg.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.groups,
                size: 100,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Nama',
            hint: 'Masukkan Nama Anggota',
            controller: _namaController,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Kode Undangan',
            hint: 'cth: TN-78961',
            controller: _kodeController,
            prefixIcon: Container(
              margin: const EdgeInsets.all(AppSpacing.xs),
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(
                Icons.vpn_key_outlined,
                size: 18,
                color: AppColors.cream,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHint() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
          children: [
            const TextSpan(text: 'Belum punya kode? Hubungi Ketua\nKelompok atau '),
            TextSpan(
              text: 'Buat Kelompok Baru',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textDarker,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              recognizer: null, // Could add TapGestureRecognizer if wanted
            ),
          ],
        ),
      ),
    );
  }
}

/// Pop-up "Berhasil Bergabung" — match Figma.
/// - Close X di pojok kanan atas
/// - Ilustrasi checkmark coklat dengan confetti dots
/// - "🎉 Berhasil Bergabung!"
/// - "Kamu sudah menjadi bagian dari kelompok ternak."
/// - Button "Lanjut" coklat full-width
class _BerhasilGabungDialog extends StatelessWidget {
  final VoidCallback onLanjut;
  final VoidCallback onClose;

  const _BerhasilGabungDialog({
    required this.onLanjut,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
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
            // Ilustrasi: checkmark circle + confetti dots
            SizedBox(
              width: 120,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Confetti dots scatter
                  ...List.generate(10, (i) {
                    final positions = [
                      [20.0, 15.0, AppColors.primary],
                      [95.0, 10.0, AppColors.accent],
                      [10.0, 50.0, AppColors.accent],
                      [105.0, 45.0, AppColors.primary],
                      [30.0, 80.0, AppColors.primary],
                      [85.0, 85.0, AppColors.accent],
                      [5.0, 25.0, AppColors.accent],
                      [110.0, 70.0, AppColors.primary],
                      [50.0, 5.0, AppColors.accent],
                      [70.0, 90.0, AppColors.primary],
                    ];
                    final p = positions[i];
                    return Positioned(
                      left: p[0] as double,
                      top: p[1] as double,
                      child: Container(
                        width: i.isEven ? 5 : 4,
                        height: i.isEven ? 5 : 4,
                        decoration: BoxDecoration(
                          color: p[2] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                  // Center checkmark circle
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Title with emoji
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Berhasil Bergabung!',
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
              'Kamu sudah menjadi bagian dari\nkelompok ternak.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Button Lanjut — coklat full-width
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onLanjut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                child: Text(
                  'Lanjut',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
