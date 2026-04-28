import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/profile_provider.dart';

/// Akun main screen — match Figma (Menu_Akun_-_Ketua_Kelompok.png).
/// Layout: thin brown header with "Akun" title, overlapping avatar card,
/// then 2 menu groups (Pengaturan Akun, Tentang Ternovia) + Keluar button.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                ),
                child: Transform.translate(
                  offset: const Offset(0, -30),
                  child: _buildUserCard(profile),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionHeader('Pengaturan Akun'),
                    const SizedBox(height: AppSpacing.xs),
                    _MenuCard(
                      icon: Icons.manage_accounts_outlined,
                      label: 'Profil',
                      onTap: () => context.push('/profil/detail'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _MenuCard(
                      icon: Icons.vpn_key_outlined,
                      label: 'Kata Sandi',
                      onTap: () => context.push('/profil/kata-sandi'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _MenuCard(
                      icon: Icons.description_outlined,
                      label: 'Dokumen Saya',
                      onTap: () => context.push('/profil/dokumen'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _MenuCard(
                      icon: Icons.group_outlined,
                      label: 'Kelola Anggota Kelompok',
                      onTap: () => context.push('/profil/kelompok'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildSectionHeader('Tentang Ternovia'),
                    const SizedBox(height: AppSpacing.xs),
                    _MenuCard(
                      iconWidget: const Text(
                        '🐂',
                        style: TextStyle(fontSize: 20),
                      ),
                      label: 'Ternovia',
                      onTap: () => context.push('/profil/tentang'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _MenuCard(
                      icon: Icons.info_outline_rounded,
                      label: 'Kebijakan Privasi',
                      onTap: () => context.push('/profil/privasi'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _MenuCard(
                      icon: Icons.menu_book_outlined,
                      label: 'Panduan Penggunaan',
                      onTap: () => context.push('/profil/panduan'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Keluar — standalone, red text
                    _LogoutButton(
                      onTap: () => _showLogoutConfirm(context),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xxl),
          bottomRight: Radius.circular(AppRadius.xxl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl + 16,
      ),
      child: Center(
        child: Text(
          'Akun',
          style: AppTypography.headingLarge.copyWith(
            color: AppColors.textOnPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar - emoji petani in cream circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              AppConstants.iconKelompokTernak,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  '👨‍🌾',
                  style: TextStyle(fontSize: 24),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.nama,
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  profile.namaKelompok,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        label,
        style: AppTypography.headingSmall.copyWith(
          color: AppColors.textDarker,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: AppColors.error),
            const SizedBox(width: AppSpacing.xs),
            Text('Keluar Akun?', style: AppTypography.headingMedium),
          ],
        ),
        content: Text(
          'Kamu akan keluar dari akun Ternovia. Data kamu tetap aman '
          'dan bisa diakses lagi dengan login ulang.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textDark,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Batal',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/onboarding');
            },
            child: Text(
              'Ya, Keluar',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final VoidCallback onTap;

  const _MenuCard({
    this.icon,
    this.iconWidget,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: iconWidget ??
                    Icon(icon, size: 22, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: const Icon(
                  Icons.logout_rounded,
                  size: 22,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Keluar',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
