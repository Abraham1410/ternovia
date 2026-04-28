import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';

/// Dokumen Saya — list dokumen kelompok yang udah pernah di-upload.
/// Match Figma (1776965164141_image.png).
///
/// Menampilkan 6 dokumen utama kelompok:
/// - Surat Permohonan SKT
/// - Susunan Pengurus & Jumlah Anggota
/// - KTP Anggota
/// - KK Anggota
/// - Berita Acara Pembentukan
/// - Daftar Hadir Pembentukan
///
/// Tiap item: header + [Surat SKT (filename)] + [Lihat File]
class DokumenSayaScreen extends StatelessWidget {
  const DokumenSayaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Dokumen Saya',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DokumenItem(
                      label: 'Surat Permohonan SKT',
                      fileName: 'Surat SKT',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DokumenItem(
                      label: 'Susunan Pengurus & Jumlah Anggota',
                      fileName: 'Surat SKT',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DokumenItem(
                      label: 'KTP Anggota',
                      fileName: 'Surat SKT',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DokumenItem(
                      label: 'KK Anggota',
                      fileName: 'Surat SKT',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DokumenItem(
                      label: 'Berita Acara Pembentukan',
                      fileName: 'Surat SKT',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DokumenItem(
                      label: 'Daftar Hadir Pembentukan',
                      fileName: 'Surat SKT',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DokumenItem extends StatelessWidget {
  final String label;
  final String fileName;

  /// Path file (optional). Kalau ada + file exists, Lihat File bisa buka PDF.
  final String? filePath;

  const _DokumenItem({
    required this.label,
    required this.fileName,
    this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: label (PDF) label
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textDarker,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: ' (PDF)',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _FilePill(
                label: fileName,
                leadingIcon: Icons.description_outlined,
                trailingIcon: Icons.close,
                onTap: () => _showInfo(context, 'File: $fileName'),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _FilePill(
                label: 'Lihat File',
                leadingIcon: Icons.visibility_outlined,
                onTap: () => _onLihatFile(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onLihatFile(BuildContext context) {
    // Kalau path ada & file exists → buka PDF viewer
    if (filePath != null && File(filePath!).existsSync()) {
      context.push('/pdf-viewer', extra: {
        'filePath': filePath!,
        'fileName': '$label.pdf',
      });
      return;
    }
    // Fallback: info dialog (karena data ini dummy, gak punya file real)
    _showInfo(
      context,
      'File "$label" belum tersedia. Upload via form pengajuan SKT dulu.',
    );
  }

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _FilePill extends StatelessWidget {
  final String label;
  final IconData leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback onTap;

  const _FilePill({
    required this.label,
    required this.leadingIcon,
    required this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                leadingIcon,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 6),
                Icon(
                  trailingIcon,
                  size: 14,
                  color: AppColors.textMuted,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
