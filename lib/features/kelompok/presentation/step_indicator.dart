import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Step indicator untuk multi-step form Buat Kelompok.
///
/// Menampilkan 3 step dengan circle + line + label.
/// Sesuai Figma: step aktif = dark brown filled, step belum aktif = light brown
class StepIndicator extends StatelessWidget {
  final int currentStep; // 1, 2, atau 3
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row of circles + lines
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            children: List.generate(labels.length * 2 - 1, (index) {
              if (index.isEven) {
                // Circle
                final stepNumber = (index ~/ 2) + 1;
                return _Circle(
                  stepNumber: stepNumber,
                  isActive: stepNumber == currentStep,
                  isCompleted: stepNumber < currentStep,
                );
              } else {
                // Line connector
                final lineAfterStep = (index ~/ 2) + 1;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: lineAfterStep < currentStep
                        ? AppColors.primary
                        : AppColors.creamMuted,
                  ),
                );
              }
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Labels
        Row(
          children: List.generate(labels.length, (i) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                child: Text(
                  '${i + 1}. ${labels[i]}',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: i + 1 == currentStep
                        ? AppColors.primary
                        : AppColors.textMuted,
                    fontWeight: i + 1 == currentStep
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  final int stepNumber;
  final bool isActive;
  final bool isCompleted;

  const _Circle({
    required this.stepNumber,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final bool filled = isActive || isCompleted;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.primary : AppColors.creamMuted,
        border: Border.all(
          color: filled ? AppColors.primary : AppColors.creamMuted,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                size: 16,
                color: AppColors.cream,
              )
            : Text(
                '$stepNumber',
                style: AppTypography.labelSmall.copyWith(
                  color: filled ? AppColors.cream : AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
      ),
    );
  }
}
