import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'ternovia_logo.dart';

/// AppBar dengan background coklat, logo Ternovia di tengah, dan optional back button.
///
/// Sesuai design Figma yang dipakai di halaman form kelompok.
class TernoviaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const TernoviaAppBar({
    super.key,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: SizedBox(
        height: 64,
        child: Stack(
          children: [
            // Logo + text di tengah
            Center(
              child: TernoviaLogoWithText(
                iconSize: 32,
                textStyle: AppTypography.headingXL.copyWith(
                  color: AppColors.textOnPrimary,
                  fontSize: 18,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            // Back button di kiri
            if (showBackButton)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.chevron_left,
                    color: AppColors.textOnPrimary,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
