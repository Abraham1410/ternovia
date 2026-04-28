import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _namaController;
  late TextEditingController _hpController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _namaController = TextEditingController(text: profile.nama);
    _hpController = TextEditingController(text: profile.nomorHp);
    _emailController = TextEditingController(text: profile.email);
    _alamatController = TextEditingController(text: profile.alamat);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Validation
    if (_namaController.text.trim().isEmpty) {
      _showError('Nama tidak boleh kosong');
      return;
    }
    if (_hpController.text.trim().length < 10) {
      _showError('Nomor HP minimal 10 digit');
      return;
    }
    if (_emailController.text.trim().isNotEmpty &&
        !_emailController.text.contains('@')) {
      _showError('Format email tidak valid');
      return;
    }
    if (_alamatController.text.trim().isEmpty) {
      _showError('Alamat tidak boleh kosong');
      return;
    }

    // Save
    ref.read(userProfileProvider.notifier).updateProfile(
          nama: _namaController.text.trim(),
          nomorHp: _hpController.text.trim(),
          email: _emailController.text.trim(),
          alamat: _alamatController.text.trim(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white, size: 20),
            SizedBox(width: AppSpacing.xs),
            Expanded(child: Text('Profil berhasil diperbarui')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );

    context.pop();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Edit Profil',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.infoBg,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary
                                  .withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Ganti foto — coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            size: 16,
                          ),
                          label: const Text('Ganti Foto'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Form fields
                  AppTextField(
                    label: 'Nama Lengkap',
                    controller: _namaController,
                    hint: 'Masukkan nama lengkap',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: 'Nomor HP',
                    controller: _hpController,
                    hint: '08xxxxxxxxxx',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'email@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    label: 'Alamat',
                    controller: _alamatController,
                    hint: 'Dusun, desa, kecamatan',
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Read-only field: NIK (gak boleh diubah)
                  _ReadOnlyField(
                    label: 'NIK (tidak bisa diubah)',
                    value: profile.nik,
                    icon: Icons.credit_card_outlined,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: 'Simpan Perubahan',
                    onPressed: _handleSave,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.creamMuted.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textMuted),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(
                Icons.lock_outline,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
