import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Role Selection Screen — "Pilih Peran Pengguna"
/// User memilih antara Peternak atau Petugas Lapangan
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background brown atas
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
                  AppColors.primary,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.chevron_left),
                        color: AppColors.textOnPrimary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.huge),

                // Logo besar
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: Column(
                    children: [
                      Icon(Icons.agriculture,
                          size: 80, color: AppColors.textOnPrimary),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'TERNOVIA',
                        style: AppTypography.logoText.copyWith(
                          color: AppColors.textOnPrimary,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dinas Peternakan Kabupaten Jombang',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textOnPrimary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom sheet card
                FadeSlideIn(
                  delay: const Duration(milliseconds: 400),
                  offsetY: 60,
                  duration: const Duration(milliseconds: 700),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundAlt,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Masuk ke Ternovia!',
                          style: AppTypography.headingLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Pilih peran pengguna yang sesuai\nuntuk melanjutkan!',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        _RoleCard(
                          icon: Icons.agriculture_outlined,
                          title: 'Masuk sebagai',
                          highlight: 'Peternak',
                          onTap: () => context.go('/dashboard'),
                          delay: const Duration(milliseconds: 600),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _RoleCard(
                          icon: Icons.people_outline,
                          title: 'Masuk sebagai',
                          highlight: 'Petugas Lapangan',
                          onTap: () => context.go('/dashboard'),
                          delay: const Duration(milliseconds: 750),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
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

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String highlight;
  final VoidCallback onTap;
  final Duration delay;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.highlight,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      delay: delay,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Icon(icon, size: 40, color: AppColors.primary),
                const SizedBox(height: AppSpacing.sm),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      TextSpan(text: '$title '),
                      TextSpan(
                        text: highlight,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
