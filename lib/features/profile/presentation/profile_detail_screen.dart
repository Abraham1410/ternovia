import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../providers/profile_provider.dart';

/// Profil detail screen — read-only view dengan button Edit.
/// Match Figma (1776965148054_image.png).
class ProfileDetailScreen extends ConsumerWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Profil',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar with edit badge
                  Center(
                    child: _AvatarWithBadge(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Edit Profil button
                  Center(
                    child: _EditProfilPill(
                      onTap: () => context.push('/profil/edit'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Container cream with all fields
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.infoBg.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ReadOnlyField(label: 'Nama', value: profile.nama),
                        const SizedBox(height: AppSpacing.sm),
                        _ReadOnlyField(label: 'NIK', value: profile.nik),
                        const SizedBox(height: AppSpacing.sm),
                        _ReadOnlyField(
                          label: 'Nama Kelompok Ternak',
                          value: profile.namaKelompok,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _ReadOnlyField(
                          label: 'Jenis Ternak',
                          value: 'Sapi Perah',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _ReadOnlyField(
                          label: 'Alamat Ternak',
                          value: profile.alamat,
                          maxLines: 2,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // No. Telepon + Peran side by side
                        Row(
                          children: [
                            Expanded(
                              child: _ReadOnlyField(
                                label: 'No. Telepon',
                                value: profile.nomorHp,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _ReadOnlyField(
                                label: 'Peran',
                                value: 'Ketua',
                                locked: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarWithBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            'O',
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.cream,
              fontWeight: FontWeight.w700,
              fontSize: 40,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cream, width: 2),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 14,
              color: AppColors.cream,
            ),
          ),
        ),
      ],
    );
  }
}

class _EditProfilPill extends StatelessWidget {
  final VoidCallback onTap;

  const _EditProfilPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.creamMuted.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColors.textDarker,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Edit Profil',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textDarker,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final bool locked;
  final int maxLines;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.locked = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textDarker,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(
              color: AppColors.creamMuted,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textDarker,
                    fontSize: 13,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (locked)
                const Icon(
                  Icons.lock_outline,
                  size: 14,
                  color: AppColors.textMuted,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
