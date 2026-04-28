import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../content/guide_content.dart';

/// Widget reusable untuk render list of GuideSection.
/// Dipake di ExpandableCard (SKT Main) — gak pake wrapper card/scaffold.
///
/// Regular sections langsung render, highlight sections dengan bg tipis.
class GuideSectionsView extends StatelessWidget {
  final List<GuideSection> sections;

  const GuideSectionsView({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(sections.length, (i) {
        final section = sections[i];
        final isLast = i == sections.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
          child: section.isHighlight
              ? _HighlightBlock(section: section)
              : _RegularBlock(section: section),
        );
      }),
    );
  }
}

class _RegularBlock extends StatelessWidget {
  final GuideSection section;

  const _RegularBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null) _buildTitle(),
        if (section.title != null &&
            (section.paragraph != null ||
                section.bullets != null ||
                section.numbered != null))
          const SizedBox(height: AppSpacing.xs),
        if (section.paragraph != null)
          Text(
            section.paragraph!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textDark,
              fontSize: 13,
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        if (section.bullets != null) ...[
          const SizedBox(height: AppSpacing.xs),
          ...section.bullets!.map(_buildBullet),
        ],
        if (section.numbered != null) ...[
          const SizedBox(height: AppSpacing.xs),
          ...List.generate(
            section.numbered!.length,
            (i) => _buildNumbered(i + 1, section.numbered![i]),
          ),
        ],
        if (section.flowStatus != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _buildFlowStatus(section.flowStatus!),
        ],
        if (section.imageAsset != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _buildImage(section.imageAsset!),
        ],
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      section.title!,
      style: AppTypography.headingSmall.copyWith(
        color: AppColors.textDarker,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4, right: 10),
            child: SizedBox(
              width: 6,
              height: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDark,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumbered(int num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$num.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDarker,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDark,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowStatus(List<String> statuses) {
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(statuses.length * 2 - 1, (i) {
          if (i.isEven) {
            final label = statuses[i ~/ 2];
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            );
          }
          return const Icon(
            Icons.arrow_forward_rounded,
            size: 14,
            color: AppColors.primary,
          );
        }),
      ),
    );
  }

  Widget _buildImage(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.creamMuted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: AppColors.border,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: AppColors.textMuted.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contoh gambar',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HighlightBlock extends StatelessWidget {
  final GuideSection section;

  const _HighlightBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.boldIntro != null)
            Text(
              section.boldIntro!,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textDarker,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          if (section.boldIntro != null && section.paragraph != null)
            const SizedBox(height: 2),
          if (section.paragraph != null)
            Text(
              section.paragraph!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDark,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
        ],
      ),
    );
  }
}
