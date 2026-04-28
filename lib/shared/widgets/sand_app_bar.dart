import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// AppBar dengan background sand/tan (warna primaryLight), title text centered.
/// Dipake di flow Pengajuan SKT dan sub-screen lainnya.
class SandAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const SandAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xxl),
          bottomRight: Radius.circular(AppRadius.xxl),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: SizedBox(
        height: 64,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.headingMedium.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (showBackButton)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  onPressed: onBackPressed ??
                      () => Navigator.of(context).maybePop(),
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
