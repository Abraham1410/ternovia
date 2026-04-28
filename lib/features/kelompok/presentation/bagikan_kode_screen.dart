import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';

/// Undang Anggota screen — match Figma (Undang_Anggota.png).
///
/// Layout (top to bottom):
/// - AppBar coklat "Undang Anggota" dengan back button
/// - Info panel kuning cream
/// - Ilustrasi bulet petani + sapi (undangan.png)
/// - Card "Kode Kelompok" cream dengan kode + icon copy
/// - Button coklat "Bagikan Kode Kelompok"
/// - Section "Cara Bergabung" dengan 3 step + arrow
/// - Info panel hijau shield
/// - Button outlined "Selesai"
class BagikanKodeScreen extends StatelessWidget {
  final String kode;

  const BagikanKodeScreen({
    super.key,
    this.kode = 'TN-8421',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Undang Anggota',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPaddingH,
                AppSpacing.md,
                AppDimensions.screenPaddingH,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info panel cream atas
                  _InfoBanner(
                    icon: Icons.info_outline_rounded,
                    backgroundColor: AppColors.infoBg,
                    iconColor: AppColors.textDarker,
                    textColor: AppColors.textDark,
                    message:
                        'Bagikan kode ini ke anggota, agar mereka bisa '
                        'bergabung ke kelompok ternakmu di Ternovia!',
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Illustration (undangan.png)
                  Center(
                    child: _UndanganIllustration(),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Kode Kelompok card
                  _KodeKelompokCard(kode: kode),
                  const SizedBox(height: AppSpacing.sm),

                  // Button "Bagikan Kode Kelompok"
                  _BagikanButton(
                    onTap: () => _handleBagikan(context),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Section "Cara Bergabung"
                  _CaraBergabungCard(),
                  const SizedBox(height: AppSpacing.sm),

                  // Info panel hijau
                  _InfoBanner(
                    icon: Icons.shield_outlined,
                    backgroundColor: AppColors.success.withValues(alpha: 0.15),
                    iconColor: AppColors.success,
                    textColor: AppColors.textDark,
                    message:
                        'Anggota cukup daftar di Ternovia lalu masukkan '
                        'kode ini untuk bergabung di Kelompok Ternak.',
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Button outlined "Selesai"
                  _SelesaiButton(
                    onTap: () => context.go('/dashboard'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBagikan(BuildContext context) async {
    final message = 'Yuk gabung ke Kelompok Ternak saya di Ternovia!\n\n'
        'Kode Kelompok: $kode\n\n'
        'Cara bergabung:\n'
        '1. Download aplikasi Ternovia\n'
        '2. Pilih "Gabung Kelompok"\n'
        '3. Masukkan kode di atas\n\n'
        'Ternovia — Dinas Peternakan Kabupaten Jombang';

    try {
      await Share.share(
        message,
        subject: 'Undangan Bergabung Kelompok Ternak — Ternovia',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membagikan: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

// ============== Components ==============

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final String message;

  const _InfoBanner({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: textColor,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UndanganIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Image.asset(
        AppConstants.undanganIllustration,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback: circular cream placeholder with farmer icon
          return Container(
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.agriculture_rounded,
              size: 80,
              color: AppColors.primary,
            ),
          );
        },
      ),
    );
  }
}

class _KodeKelompokCard extends StatelessWidget {
  final String kode;

  const _KodeKelompokCard({required this.kode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: [
          Text(
            'Kode Kelompok',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textDark,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () => _copyKode(context),
              borderRadius: BorderRadius.circular(AppRadius.button),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.creamMuted.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kode,
                      style: AppTypography.headingLarge.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(
                      Icons.content_copy_rounded,
                      size: 20,
                      color: AppColors.textDarker,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyKode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: kode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle,
                color: AppColors.white, size: 18),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text('Kode "$kode" berhasil disalin'),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _BagikanButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BagikanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        child: Text(
          'Bagikan Kode Kelompok',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _CaraBergabungCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cara Bergabung',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StepItem(
                  icon: Icons.qr_code_2_rounded,
                  label: 'Kirim Kode\nKelompok',
                ),
              ),
              _StepArrow(),
              Expanded(
                child: _StepItem(
                  icon: Icons.keyboard_rounded,
                  label: 'Anggota Masukkan\nKode Kelompok',
                ),
              ),
              _StepArrow(),
              Expanded(
                child: _StepItem(
                  icon: Icons.waving_hand_rounded,
                  label: 'Berhasil\nBergabung\nKelompok Ternak',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StepItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.cream, size: 24),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textDark,
            fontSize: 10,
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StepArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 14, left: 2, right: 2),
      child: Icon(
        Icons.keyboard_double_arrow_right_rounded,
        size: 18,
        color: AppColors.primary,
      ),
    );
  }
}

class _SelesaiButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SelesaiButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.creamMuted.withValues(alpha: 0.4),
          side: BorderSide(
            color: AppColors.creamMuted,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        child: Text(
          'Selesai',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textDarker,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
