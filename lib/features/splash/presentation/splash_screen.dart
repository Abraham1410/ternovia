import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/ternovia_logo.dart';

/// SplashScreen — 3 stage animation.
///
/// FIX v3: Logo gak di-shift lagi. Sebelumnya di-shift -50px ke kiri
/// biar muat text di sebelahnya, tapi itu bikin gambar off-center.
/// Sekarang pake Row dengan mainAxisSize.min dalam Center.
/// Saat stage 3 text fade in, Row otomatis re-center karena width-nya
/// bertambah sesuai ukuran text.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<Color?> _bgColor;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;

  int _stage = 1;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _bgColor = ColorTween(
      begin: AppColors.primary,
      end: AppColors.cream,
    ).animate(CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    ));

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    developer.log('[SPLASH] Stage 1: Solid brown', name: 'ternovia.splash');

    await Future.delayed(
      const Duration(milliseconds: AppConstants.splashStage1Duration),
    );

    if (!mounted) return;
    developer.log('[SPLASH] Stage 2: Logo fade in', name: 'ternovia.splash');

    setState(() => _stage = 2);
    _bgController.forward();
    _logoController.forward();

    await Future.delayed(
      const Duration(milliseconds: AppConstants.splashStage2Duration),
    );

    if (!mounted) return;
    developer.log('[SPLASH] Stage 3: Text fade in', name: 'ternovia.splash');

    setState(() => _stage = 3);
    _textController.forward();

    await Future.delayed(
      const Duration(milliseconds: AppConstants.splashStage3Duration),
    );

    if (!mounted) return;
    developer.log('[SPLASH] Navigate to /onboarding',
        name: 'ternovia.splash');

    context.go('/onboarding');
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _bgController,
        _logoController,
        _textController,
      ]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: _bgColor.value ?? AppColors.primary,
          body: SafeArea(
            // IntrinsicWidth + Center + Row(mainAxisSize.min) = natural centering
            child: Center(
              child: _stage == 1
                  ? const SizedBox.shrink()
                  : Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const TernoviaLogo(size: 100),
                            if (_stage >= 3) ...[
                              const SizedBox(width: AppSpacing.sm),
                              Opacity(
                                opacity: _textOpacity.value,
                                child: Text(
                                  AppConstants.appName,
                                  style: AppTypography.headingXL.copyWith(
                                    fontSize: 32,
                                    letterSpacing: 3.0,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
