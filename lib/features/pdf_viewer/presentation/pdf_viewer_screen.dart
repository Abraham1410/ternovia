import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Full-screen PDF viewer pake flutter_pdfview.
///
/// Requirements:
/// - File harus exist di path yang di-kasih
/// - Kalo fail load → tampil error state dengan tombol retry/back
///
/// Features:
/// - Page indicator ("Hal 1 dari 5") di bawah
/// - Back button di appbar
/// - Loading indicator saat render awal
/// - Fit width, swipe horizontal antar page
class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;

  const PdfViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final fileExists = File(widget.filePath).existsSync();

    return Scaffold(
      backgroundColor: AppColors.textDarker,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.fileName,
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.cream,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Stack(
        children: [
          if (!fileExists)
            _buildErrorState(
              'File tidak ditemukan di:\n${widget.filePath}',
            )
          else if (_errorMessage != null)
            _buildErrorState(_errorMessage!)
          else
            PDFView(
              filePath: widget.filePath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              fitPolicy: FitPolicy.WIDTH,
              onRender: (pages) {
                setState(() {
                  _totalPages = pages ?? 0;
                  _isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  _errorMessage = 'Gagal membuka PDF: $error';
                });
              },
              onPageError: (page, error) {
                setState(() {
                  _errorMessage = 'Error di halaman $page: $error';
                });
              },
              onPageChanged: (page, total) {
                setState(() {
                  _currentPage = page ?? 0;
                  _totalPages = total ?? 0;
                });
              },
            ),
          if (fileExists && !_isReady && _errorMessage == null)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.cream,
              ),
            ),
          // Page indicator di bawah
          if (_isReady && _errorMessage == null && _totalPages > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.md,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textDarker.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  child: Text(
                    'Hal ${_currentPage + 1} dari $_totalPages',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.cream,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 80,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Tidak Dapat Membuka PDF',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.cream,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Kembali'),
          ),
        ],
      ),
    );
  }
}
