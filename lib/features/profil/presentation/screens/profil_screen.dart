import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Text('Akun',
                style: AppTypography.headingLarge
                    .copyWith(color: AppColors.textOnPrimary)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                FadeSlideIn(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primarySoft,
                          child: Icon(Icons.person, color: AppColors.surface),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jenoardi',
                                  style: AppTypography.labelLarge
                                      .copyWith(fontWeight: FontWeight.w600)),
                              Text('Kelompok Ternak Sukses Makmur',
                                  style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: Text('Pengaturan Akun',
                      style: AppTypography.labelLarge.copyWith(
                          color: AppColors.textSecondary)),
                ),
                const SizedBox(height: AppSpacing.sm),
                StaggeredList(
                  baseDelay: const Duration(milliseconds: 200),
                  children: const [
                    _MenuItem(
                        icon: Icons.person_outline, title: 'Profil'),
                    SizedBox(height: AppSpacing.xs),
                    _MenuItem(
                        icon: Icons.lock_outline, title: 'Kata Sandi'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 400),
                  child: Text('Tentang Ternovia',
                      style: AppTypography.labelLarge.copyWith(
                          color: AppColors.textSecondary)),
                ),
                const SizedBox(height: AppSpacing.sm),
                StaggeredList(
                  baseDelay: const Duration(milliseconds: 500),
                  children: const [
                    _MenuItem(
                        icon: Icons.info_outline, title: 'Ternovia'),
                    SizedBox(height: AppSpacing.xs),
                    _MenuItem(
                        icon: Icons.shield_outlined,
                        title: 'Kebijakan Privasi'),
                    SizedBox(height: AppSpacing.xs),
                    _MenuItem(
                        icon: Icons.menu_book_outlined,
                        title: 'Panduan Penggunaan'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 800),
                  child: _MenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    color: AppColors.danger,
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

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;

  const _MenuItem({required this.icon, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.textPrimary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: itemColor, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(title,
                style: AppTypography.labelLarge.copyWith(color: itemColor)),
          ),
          Icon(Icons.chevron_right, color: itemColor.withOpacity(0.5)),
        ],
      ),
    );
  }
}
