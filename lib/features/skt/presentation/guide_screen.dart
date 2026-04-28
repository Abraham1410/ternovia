import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../content/guide_content.dart';

/// Generic guide screen — render list of GuideSection.
/// Dipake buat Panduan, Syarat & Ketentuan, dan Contoh Dokumen.
///
/// Supports:
/// - title + paragraph + bullets + numbered
/// - flowStatus (arrow flow visualization)
/// - imageAsset (PNG/JPG)
/// - isHighlight (tips / warning box)
/// - boldIntro (inline bold prefix)
class GuideScreen extends StatelessWidget {
  final String title;
  final List<GuideSection> sections;

  const GuideScreen({
    super.key,
    required this.title,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: title,
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bungkus semua section dalam 1 white card sesuai design
                  // (kecuali highlight, yang berdiri sendiri)
                  _buildCombinedCard(),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Bundle regular sections dalam 1 white card + highlight sections
  /// berdiri sendiri setelahnya.
  Widget _buildCombinedCard() {
    final regularSections =
        sections.where((s) => !s.isHighlight).toList();
    final highlightSections =
        sections.where((s) => s.isHighlight).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(regularSections.length, (i) {
              final section = regularSections[i];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: i < regularSections.length - 1
                      ? AppSpacing.md
                      : 0,
                ),
                child: _SectionContent(section: section),
              );
            }),
          ),
        ),
        ...highlightSections.map((s) => Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: _HighlightBox(section: s),
            )),
      ],
    );
  }
}

class _SectionContent extends StatelessWidget {
  final GuideSection section;

  const _SectionContent({required this.section});

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
        fontSize: 15,
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
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: AppColors.primary,
            ),
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
          // Placeholder kalau asset gak ada (belum di-upload)
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

class _HighlightBox extends StatelessWidget {
  final GuideSection section;

  const _HighlightBox({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
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
