import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/kandang_provider.dart';

/// Detail Ternak screen — table list ternak individu dengan kondisi per ekor.
/// Header coklat dengan search, Insight Kesehatan, table No/Ternak/Kondisi/Catatan.
class DetailTernakScreen extends ConsumerStatefulWidget {
  final String kandangId;

  const DetailTernakScreen({super.key, required this.kandangId});

  @override
  ConsumerState<DetailTernakScreen> createState() =>
      _DetailTernakScreenState();
}

class _DetailTernakScreenState extends ConsumerState<DetailTernakScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ternakList = ref.watch(ternakIndividuProvider(widget.kandangId));

    final filtered = _query.isEmpty
        ? ternakList
        : ternakList
            .where((t) =>
                t.kodeTernak.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.screenPaddingH,
                  AppSpacing.sm,
                  AppDimensions.screenPaddingH,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInsightCard(),
                    const SizedBox(height: AppSpacing.md),
                    _buildTable(filtered),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xxl),
          bottomRight: Radius.circular(AppRadius.xxl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white, size: 18),
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Detail Ternak',
                    style: AppTypography.headingLarge.copyWith(
                      color: AppColors.textOnPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Row(
              children: [
                const Icon(Icons.search,
                    color: AppColors.textMuted, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Cari ternak',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm + 2,
                      ),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insight Kesehatan',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.orange, size: 22),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Sapi Perah #107 17% terindikasi Diare, beri vitamin C '
                  'dan antibiotic ringan segera!',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textDark,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<TernakIndividu> list) {
    return Column(
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  'No',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Ternak',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Kondisi',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Catatan',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...list.asMap().entries.map((e) {
          final i = e.key;
          final t = e.value;
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${i + 1}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textDark,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    t.kodeTernak,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    t.kondisi.label,
                    style: AppTypography.bodySmall.copyWith(
                      color: t.kondisi.color,
                      fontWeight: t.kondisi == KondisiTernak.aktifitas
                          ? FontWeight.w400
                          : FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    t.catatan ?? '-',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textDark,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
