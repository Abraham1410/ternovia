import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/sand_app_bar.dart';

/// Kata Sandi screen — ganti password.
/// Match Figma (1776965155874_image.png).
class KataSandiScreen extends StatefulWidget {
  const KataSandiScreen({super.key});

  @override
  State<KataSandiScreen> createState() => _KataSandiScreenState();
}

class _KataSandiScreenState extends State<KataSandiScreen> {
  final _lamaController = TextEditingController();
  final _baruController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  bool _obscureLama = true;
  bool _obscureBaru = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _lamaController.dispose();
    _baruController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  void _handleKonfirmasi() {
    if (_lamaController.text.isEmpty) {
      _showError('Kata sandi lama tidak boleh kosong');
      return;
    }
    if (_baruController.text.length < 8) {
      _showError('Kata sandi baru minimal 8 karakter');
      return;
    }
    if (_baruController.text != _konfirmasiController.text) {
      _showError('Konfirmasi kata sandi tidak cocok');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white, size: 20),
            SizedBox(width: AppSpacing.xs),
            Expanded(
                child: Text('Kata sandi berhasil diubah')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
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
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Kata Sandi',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.infoBg.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PasswordField(
                          label: 'Kata Sandi Lama',
                          hint: 'Masukkan Kata Sandi Lama',
                          controller: _lamaController,
                          obscure: _obscureLama,
                          onToggle: () => setState(
                              () => _obscureLama = !_obscureLama),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _PasswordField(
                          label: 'Kata Sandi Baru',
                          hint: 'Masukkan Kata Sandi Baru',
                          controller: _baruController,
                          obscure: _obscureBaru,
                          onToggle: () => setState(
                              () => _obscureBaru = !_obscureBaru),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _PasswordField(
                          label: 'Konfirmasi Kata Sandi',
                          hint: 'Konfirmasi Kata Sandi',
                          controller: _konfirmasiController,
                          obscure: _obscureKonfirmasi,
                          onToggle: () => setState(() =>
                              _obscureKonfirmasi = !_obscureKonfirmasi),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: 'Konfirmasi Kata Sandi',
                    onPressed: _handleKonfirmasi,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.obscure,
    required this.onToggle,
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
        TextField(
          controller: controller,
          obscureText: obscure,
          style: AppTypography.bodyMedium.copyWith(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs + 2,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(
                color: AppColors.creamMuted,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: BorderSide(
                color: AppColors.creamMuted,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
