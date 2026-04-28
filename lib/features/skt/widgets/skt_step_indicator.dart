import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Step indicator khusus SKT — 4 step dengan label di bawah circle.
/// Step aktif + step sebelumnya = filled primary.
class SktStepIndicator extends StatelessWidget {
  final int currentStep; // 1..4
  final List<String> labels;

  const SktStepIndicator({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: List.generate(labels.length * 2 - 1, (index) {
              if (index.isEven) {
                final stepNumber = (index ~/ 2) + 1;
                return _Circle(
                  stepNumber: stepNumber,
                  isActive: stepNumber == currentStep,
                  isCompleted: stepNumber < currentStep,
                );
              } else {
                final lineAfter = (index ~/ 2) + 1;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: lineAfter < currentStep
                        ? AppColors.primary
                        : AppColors.creamMuted,
                  ),
                );
              }
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: List.generate(labels.length, (i) {
            final isActive = i + 1 == currentStep;
            final isDone = i + 1 < currentStep;
            return Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                child: Text(
                  '${i + 1}. ${labels[i]}',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    color: (isActive || isDone)
                        ? AppColors.primary
                        : AppColors.textMuted,
                    fontWeight: isActive
                        ? FontWeight.w700
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
    final filled = isActive || isCompleted;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.primary : AppColors.creamMuted,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                size: 18,
                color: AppColors.cream,
              )
            : Text(
                '$stepNumber',
                style: AppTypography.labelMedium.copyWith(
                  color: filled ? AppColors.cream : AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}
