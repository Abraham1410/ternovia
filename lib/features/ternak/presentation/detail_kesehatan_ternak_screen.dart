import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/kandang_provider.dart';

/// Detail Kesehatan Ternak Screen — diakses dari button "Lihat Detail Kesehatan"
/// di Tab Kesehatan.
///
/// Berisi:
/// - Header coklat dengan back button + title + search bar (search visual only)
/// - Insight Kesehatan card (warning box)
/// - Table: No | Ternak | Kondisi | Catatan (row alternate warna)
/// - Rekomendasi Penanganan — horizontal scroll card (Artikel & Tips)
///
/// Data source: kandang pertama di list (aggregate view sementara).
/// Kalau ke depannya mau filter per kandang, tinggal terima `kandangId`
/// sebagai parameter di constructor.
class DetailKesehatanTernakScreen extends ConsumerStatefulWidget {
  const DetailKesehatanTernakScreen({super.key});

  // Local lighter cream palette — scope screen ini aja, biar tampilan
  // lebih airy tanpa ubah global AppColors.
  // Pair:
  //   _bgLight (#FFFBF5) — screen background, lebih terang dari AppColors.cream
  //   _rowAlt  (#FAEFDF) — row alternate table, lebih subtle dari infoBg
  static const Color _bgLight = Color(0xFFFFFBF5);
  static const Color _rowAlt = Color(0xFFFAEFDF);

  @override
  ConsumerState<DetailKesehatanTernakScreen> createState() =>
      _DetailKesehatanTernakScreenState();
}

class _DetailKesehatanTernakScreenState
    extends ConsumerState<DetailKesehatanTernakScreen> {
  final _searchController = TextEditingController();
  // ignore: unused_field
  String _query = ''; // TODO: wire filter logic nanti (visual only dulu)

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil ternak dari kandang pertama (aggregate view sementara).
    final kandangList = ref.watch(kandangListProvider);
    final firstKandangId = kandangList.isNotEmpty ? kandangList.first.id : '';
    final ternakList = firstKandangId.isEmpty
        ? const <TernakIndividu>[]
        : ref.watch(ternakIndividuProvider(firstKandangId));

    return Scaffold(
      backgroundColor: DetailKesehatanTernakScreen._bgLight,
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
                    _buildTable(ternakList),
                    const SizedBox(height: AppSpacing.lg),
                    const _RekomendasiSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER — back + title "Detail Kesehatan Ternak" + search bar
  // ============================================================
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
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Detail Kesehatan Ternak',
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
                      // Force putih biar konsisten, fix belang
                      filled: true,
                      fillColor: AppColors.white,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm + 2,
                      ),
                    ),
                    // TODO: wire filter logic nanti — untuk sekarang visual only
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

  // ============================================================
  // INSIGHT CARD — warning box
  // ============================================================
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

  // ============================================================
  // TABLE — No | Ternak | Kondisi | Catatan (row alternate warna)
  // ============================================================
  Widget _buildTable(List<TernakIndividu> list) {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Column(
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
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
            // Data rows — alternate warna cream muted
            ...list.asMap().entries.map((e) {
              final i = e.key;
              final t = e.value;
              final isAlternate = i % 2 == 1; // baris 2, 4, 6... → cream muted
              return Container(
                color: isAlternate
                    ? DetailKesehatanTernakScreen._rowAlt
                    : AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
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
        ),
      ),
    );
  }
}

// ============================================================
// REKOMENDASI PENANGANAN SECTION — horizontal scroll card
// ============================================================
class _RekomendasiSection extends StatelessWidget {
  const _RekomendasiSection();

  // Dummy articles — nanti tinggal ganti imagePath pake asset kamu
  static const _articles = [
    _ArtikelData(
      judul: 'Pencegahan Diare dan Cara Mengobatinya',
      imagePath: null, // e.g. 'assets/images/artikel_diare.png'
    ),
    _ArtikelData(
      judul: 'Panduan Nutrisi Sapi Perah',
      imagePath: null, // e.g. 'assets/images/artikel_nutrisi.png'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rekomendasi Penanganan',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textDarker,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _articles.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) => _ArtikelCard(data: _articles[i]),
          ),
        ),
      ],
    );
  }
}

class _ArtikelData {
  final String judul;
  final String? imagePath;

  const _ArtikelData({required this.judul, this.imagePath});
}

class _ArtikelCard extends StatelessWidget {
  final _ArtikelData data;

  const _ArtikelCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          children: [
            // Background image atau placeholder
            Positioned.fill(child: _buildImage()),
            // Label "Artikel & Tips" di kiri bawah
            Positioned(
              left: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Artikel & Tips',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Kalau ada asset, pake Image.asset. Kalau gak ada, fallback placeholder.
    if (data.imagePath != null) {
      return Image.asset(
        data.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.creamMuted,
      child: const Center(
        child: Icon(
          Icons.pets_rounded,
          size: 48,
          color: AppColors.primaryAccent,
        ),
      ),
    );
  }
}
