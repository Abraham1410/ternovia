import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Reusable animated success dialog
/// Sesuai design: "Berhasil Bergabung!", "Berhasil Menambahkan Ternak!", dll
///
/// Motion: scale-in dengan elastic curve + checkmark bouncy + content fade
///
/// Usage:
///   showDialog(
///     context: context,
///     barrierDismissible: false,
///     builder: (_) => SuccessDialog(
///       title: 'Berhasil Bergabung!',
///       message: 'Kamu sudah menjadi bagian dari kelompok ternak.',
///       onConfirm: () => Navigator.pop(context),
///     ),
///   );
class SuccessDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Lanjut',
    required this.onConfirm,
  });

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _checkController;
  late final Animation<double> _scale;
  late final Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _checkScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );

    _scaleController.forward().then((_) => _checkController.forward());
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.backgroundAlt,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _checkScale,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.textOnPrimary,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('🎉 ${widget.title}',
                  style: AppTypography.headingMedium.copyWith(
                      color: AppColors.primary)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onConfirm,
                  child: Text(widget.confirmLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
