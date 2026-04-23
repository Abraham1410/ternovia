import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Splash Screen Ternovia dengan motion sequence sesuai Figma:
///
/// 1. Stage 1 (0ms    → 800ms)  : Solid brown full screen (Splash Screen 1)
/// 2. Stage 2 (800ms  → 1400ms) : Brown background dengan fade transition
/// 3. Stage 3 (1400ms → 2400ms) : Background fade ke cream + logo T muncul (scale + fade)
/// 4. Stage 4 (2400ms → 3400ms) : Text "TERNOVIA" slide in dari kanan
/// 5. Stage 5 (3400ms → 4000ms) : Hold + navigate ke onboarding
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _logoController;
  late final AnimationController _textController;

  late final Animation<Color?> _bgColor;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // System UI — bar transparan putih untuk splash
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Background controller: brown → cream
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bgColor = ColorTween(
      begin: AppColors.primary,
      end: AppColors.background,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));

    // Logo controller: scale + fade in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    // Text controller: slide in dari kanan + fade
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0.8, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Stage 1: Hold brown 800ms (splash screen 1 & 2 Figma)
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // Stage 2 → 3: Fade brown ke cream
    _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // Stage 3: Logo muncul (splash screen 6 Figma)
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // Stage 4: Text TERNOVIA slide in (splash screen 7 Figma)
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1200));

    // Stage 5: Navigate ke onboarding
    _navigationTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: _bgColor.value,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo icon T
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoFade.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildLogoIcon(),
                ),
                const SizedBox(width: 12),

                // Text TERNOVIA
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return ClipRect(
                      child: FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'TERNOVIA',
                    style: AppTypography.logoText.copyWith(
                      fontSize: 32,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Logo icon — placeholder SVG-like built dengan CustomPainter
  /// Ganti dengan Image.asset(AppAssets.logoIcon) setelah asset tersedia
  Widget _buildLogoIcon() {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(painter: _TernoviaLogoPainter()),
    );
  }
}

/// Painter untuk logo T Ternovia (simplified bull-head dengan huruf T)
/// Ini placeholder — nanti ganti dengan asset PNG/SVG dari Figma
class _TernoviaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Horn kiri
    final hornLeft = Path()
      ..moveTo(w * 0.25, h * 0.15)
      ..quadraticBezierTo(w * 0.1, h * 0.05, w * 0.05, h * 0.25)
      ..quadraticBezierTo(w * 0.15, h * 0.3, w * 0.3, h * 0.35);
    canvas.drawPath(hornLeft, strokePaint);

    // Horn kanan
    final hornRight = Path()
      ..moveTo(w * 0.75, h * 0.15)
      ..quadraticBezierTo(w * 0.9, h * 0.05, w * 0.95, h * 0.25)
      ..quadraticBezierTo(w * 0.85, h * 0.3, w * 0.7, h * 0.35);
    canvas.drawPath(hornRight, strokePaint);

    // Body T - vertical
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.4, h * 0.3, w * 0.2, h * 0.6),
        const Radius.circular(3),
      ),
      paint,
    );

    // Body T - horizontal (top bar)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.2, h * 0.3, w * 0.6, h * 0.12),
        const Radius.circular(3),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
