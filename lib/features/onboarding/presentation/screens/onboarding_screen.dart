import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Onboarding Screen — "Selamat Datang!" (frame "Onboard 16" di Figma)
/// Motion: staggered fade-in untuk logo → title → subtitle → hero → button
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // Logo
              FadeSlideIn(
                delay: const Duration(milliseconds: 100),
                child: _LogoHeader(),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // Title
              FadeSlideIn(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  AppConstants.onboardingWelcomeTitle,
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              FadeSlideIn(
                delay: const Duration(milliseconds: 450),
                child: Text(
                  AppConstants.onboardingWelcomeSubtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Hero image (placeholder — ganti dengan Image.asset)
              Expanded(
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 600),
                  offsetY: 40,
                  duration: const Duration(milliseconds: 800),
                  child: _HeroPlaceholder(),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // CTA Button
              FadeSlideIn(
                delay: const Duration(milliseconds: 900),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/role-selection'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Mulai Sekarang'),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.agriculture, color: AppColors.primary, size: 24),
            const SizedBox(width: 6),
            Text(
              'TERNOVIA',
              style: AppTypography.logoText.copyWith(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          AppConstants.appTagline,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        color: AppColors.backgroundAlt,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 60, color: AppColors.primarySoft),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Letakkan asset hero onboarding\n(sapi, ayam, telur) di sini',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
