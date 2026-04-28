import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/ternovia_logo.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _handleStart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyHasSeenOnboarding, true);

    if (mounted) {
      context.go('/pilih-peran');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                // Header - padded
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPaddingH,
                  ),
                  child: _buildHeader(),
                ),
                const SizedBox(height: AppSpacing.xxl),
                // Title - padded
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPaddingH,
                  ),
                  child: _buildTitleSection(),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Hero image - FULL WIDTH, no horizontal padding
                Expanded(child: _buildHeroImage()),
                const SizedBox(height: AppSpacing.lg),
                // Button - padded
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPaddingH,
                  ),
                  child: CreamButton(
                    label: 'Mulai Sekarang',
                    onPressed: _handleStart,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          TernoviaLogoWithText(
            iconSize: 36,
            textStyle: AppTypography.headingXL.copyWith(
              color: AppColors.textOnPrimary,
              fontSize: 22,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang!',
          style: AppTypography.displayLarge.copyWith(
            color: AppColors.textOnPrimary,
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Mulai cara baru kelola ternak dengan\nlebih mudah dan teratur.',
          style: AppTypography.subtitleOnPrimary.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.9),
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    // ClipRect: biar gambar yang di-translate ke bawah gak overlow ke
    // widget tetangga (button "Mulai Sekarang") di bawahnya.
    return ClipRect(
      child: SizedBox(
        width: double.infinity,
        child: Transform.translate(
          // ⚠️ ADJUST POSISI GAMBAR DI SINI ⚠️
          // Offset(x, y):
          //   y > 0 → geser ke BAWAH (mepetin ke bawah)
          //   y < 0 → geser ke ATAS
          //   x > 0 → geser ke KANAN
          //   x < 0 → geser ke KIRI
          // Naikin angka 30 jadi 40, 50 dst kalau mau lebih turun
          offset: const Offset(0, 40),
          child: Image.asset(
            AppConstants.onboardingHero,
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
            errorBuilder: (context, error, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 80,
                        color: AppColors.creamMuted.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Asset onboarding_hero.png tidak ditemukan',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.creamMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}