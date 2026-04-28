import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// LayananScreen — menu layanan Peternak.
///
/// Layout sesuai Figma (tanpa overlap card):
/// - Top brown section: title "Layanan" + search bar
/// - Gap normal
/// - 3 layanan cards (SKT, Konfirmasi Bantuan, Sample Pakan)
/// - Riwayat Pengajuan Terakhir + Riwayat SKT
class LayananScreen extends ConsumerStatefulWidget {
  const LayananScreen({super.key});

  @override
  ConsumerState<LayananScreen> createState() => _LayananScreenState();
}

class _LayananScreenState extends ConsumerState<LayananScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Top brown section sebagai sliver biar scroll natural
            SliverToBoxAdapter(child: _buildTopSection()),
            // Content area
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPaddingH,
                AppSpacing.lg,
                AppDimensions.screenPaddingH,
                AppSpacing.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildLayananList(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildRiwayatSection(
                    title: 'Riwayat Pengajuan Terakhir',
                    items: [
                      const _RiwayatItem(
                        jenis: 'Pengajuan Sample Pakan',
                        detail: 'Pakan konsentrat sapi perah',
                        detailIcon: Icons.grain,
                        tanggal: '02 Januari 2026',
                        statusLabel: 'Dianalisis Laboratorium',
                        statusColor: AppColors.warning,
                        statusIcon: Icons.hourglass_empty,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildRiwayatSection(
                    title: 'Riwayat Pengajuan SKT',
                    items: [
                      const _RiwayatItem(
                        jenis: 'Pengajuan SKT',
                        detail: 'Terkirim 8 Dokumen',
                        detailIcon: Icons.description_outlined,
                        tanggal: '02 Januari 2026',
                        statusLabel: 'Selesai',
                        statusColor: AppColors.success,
                        statusIcon: Icons.check_circle,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xxl),
          bottomRight: Radius.circular(AppRadius.xxl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPaddingH,
        AppSpacing.md,
        AppDimensions.screenPaddingH,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Text(
              'Layanan',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Cari layanan',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textMuted,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }

  Widget _buildLayananList() {
    return Column(
      children: [
        _LayananCard(
          icon: Icons.description_outlined, // fallback
          iconAsset: 'assets/icons/pengajuan_skt.png',
          title: 'Pengajuan SKT',
          subtitle: 'Urus legalitas kelompok',
          onTap: () => context.push('/layanan/skt'),
        ),
        const SizedBox(height: AppSpacing.sm),
        _LayananCard(
          icon: Icons.group_outlined, // fallback
          iconAsset: 'assets/icons/layanan_bantuan.png',
          title: 'Konfirmasi Bantuan',
          subtitle: 'Konfirmasi bantuan ternak / alat',
          onTap: () {},
        ),
        const SizedBox(height: AppSpacing.sm),
        _LayananCard(
          icon: Icons.science_outlined, // fallback
          iconAsset: 'assets/icons/sampel_pakan.png',
          title: 'Pengajuan Sample Pakan',
          subtitle: 'Cek kualitas pakan',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildRiwayatSection({
    required String title,
    required List<_RiwayatItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.textDarker,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ...items.map((item) => _RiwayatTile(item: item)),
      ],
    );
  }
}

class _LayananCard extends StatelessWidget {
  final IconData icon;

  /// Optional asset path. Kalau ada, akan dipakai instead of [icon].
  /// Asset di-tint pakai AppColors.primary biar match style.
  final String? iconAsset;

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LayananCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
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
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: iconAsset != null
                      ? Image.asset(
                          iconAsset!,
                          color: AppColors.primary,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            icon,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        )
                      : Icon(
                          icon,
                          size: 32,
                          color: AppColors.primary,
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiwayatItem {
  final String jenis;
  final String detail;
  final IconData detailIcon;
  final String tanggal;
  final String statusLabel;
  final Color statusColor;
  final IconData statusIcon;

  const _RiwayatItem({
    required this.jenis,
    required this.detail,
    required this.detailIcon,
    required this.tanggal,
    required this.statusLabel,
    required this.statusColor,
    required this.statusIcon,
  });
}

class _RiwayatTile extends StatelessWidget {
  final _RiwayatItem item;

  const _RiwayatTile({required this.item});

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
          Text(
            item.jenis,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(item.detailIcon,
                  size: 16, color: AppColors.textMuted),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  item.detail,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 16, color: AppColors.textMuted),
              const SizedBox(width: AppSpacing.xs),
              Text(
                item.tanggal,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: item.statusColor,
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.statusIcon,
                    size: 16, color: AppColors.white),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  item.statusLabel,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
