import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/ternovia_logo.dart';

/// PilihPeranScreen — user pilih role Peternak atau Petugas Lapangan.
///
/// FIX v3:
/// - Background image pake Align+FractionallySizedBox biar gak ke-crop aneh.
///   Image di-position di bottom, ukurannya 60% dari tinggi screen.
/// - Back button pake context.go('/onboarding'), bukan context.pop(),
///   karena navigation dari onboarding pake go (replace stack).
///
/// FIX v4:
/// - Icon role card sekarang support asset PNG via [iconAsset].
///   Peternak pake assets/icons/peternak.png
///   Petugas pake assets/icons/petugas.png
///   Fallback ke Material Icon kalau asset gak ada.
class PilihPeranScreen extends ConsumerWidget {
  const PilihPeranScreen({super.key});

  Future<void> _handleSelectRole(
      BuildContext context, UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keySelectedRole, role.code);

    if (!context.mounted) return;

    if (role == UserRole.peternak) {
      context.go('/kelompok');
    } else {
      context.go('/login/petugas');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Positioned.fill(child: _buildBackground()),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: AppSpacing.md),
                _buildBrandSection(),
                // Spacer atas biar card center vertikal
                const Spacer(),
                // Glass card — width full screen, border radius semua sisi
                _buildGlassCard(context),
                // Spacer bawah biar card center vertikal
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// FIX: image di-align ke bottom, gak cover full screen.
  /// Biar subject (sapi/ayam) tetep kelihatan utuh.
  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Solid bg
        Container(color: AppColors.primary),
        // Hero image di bottom, ukuran 60% tinggi screen
        Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.6,
            widthFactor: 1.0,
            child: Image.asset(
              AppConstants.onboardingHero,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        // Dark overlay di atas image biar card cream kontras
        Container(color: AppColors.primary.withValues(alpha: 0.65)),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // FIX: pakai context.go ke route sebelumnya, bukan pop.
              // Karena flow pakai go (replace stack), gak ada yang bisa di-pop.
              context.go('/onboarding');
            },
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.textOnPrimary,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      children: [
        const TernoviaLogo(size: 80),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppConstants.appName,
          style: AppTypography.headingXL.copyWith(
            color: AppColors.textOnPrimary,
            fontSize: 20,
            letterSpacing: 3.0,
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
              style: AppTypography.captionOnPrimary,
            ),
          ],
        ),
      ],
    );
  }

  /// Glass card center vertikal di layar.
  /// - Horizontal margin dari screen padding
  /// - Corner radius semua sisi (xl)
  Widget _buildGlassCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.creamMuted.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.creamMuted.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Masuk ke Ternovia!',
            textAlign: TextAlign.center,
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pilih peran pengguna yang sesuai\nuntuk melanjutkan!',
            textAlign: TextAlign.center,
            style: AppTypography.subtitleOnPrimary,
          ),
          const SizedBox(height: AppSpacing.lg),
          _RoleCard(
            // Icon Material sebagai fallback (kalau asset gagal load)
            icon: Icons.person_outline,
            // Asset PNG yang sebenernya dipake
            iconAsset: 'assets/icons/peternak.png',
            title: 'Masuk sebagai',
            titleBold: 'Peternak',
            onTap: () => _handleSelectRole(context, UserRole.peternak),
          ),
          const SizedBox(height: AppSpacing.md),
          _RoleCard(
            icon: Icons.badge_outlined,
            iconAsset: 'assets/icons/petugas.png',
            title: 'Masuk sebagai',
            titleBold: 'Petugas Lapangan',
            onTap: () =>
                _handleSelectRole(context, UserRole.petugasLapangan),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;

  /// Optional asset path. Kalau ada, akan dipakai instead of [icon].
  /// Asset di-tint pakai AppColors.textDark biar match style.
  final String? iconAsset;

  final String title;
  final String titleBold;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.titleBold,
    required this.onTap,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  // Render asset PNG kalau ada, fallback ke Material Icon
                  if (iconAsset != null)
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: Image.asset(
                        iconAsset!,
                        color: AppColors.textDark,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          icon,
                          size: 36,
                          color: AppColors.textDark,
                        ),
                      ),
                    )
                  else
                    Icon(
                      icon,
                      size: 36,
                      color: AppColors.textDark,
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                      children: [
                        TextSpan(text: '$title '),
                        TextSpan(
                          text: titleBold,
                          style: AppTypography.headingSmall.copyWith(
                            color: AppColors.textDarker,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}