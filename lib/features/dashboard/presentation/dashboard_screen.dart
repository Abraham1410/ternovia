import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../widgets/aktivitas_card.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/kelompok_card.dart';
import '../widgets/produksi_card.dart';

/// DashboardScreen — home beranda Peternak (Ketua Kelompok).
/// Layout compact sesuai Figma — padding tight, card height minimal.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _namaUser = 'Jenoardi';
  static const _namaKelompok = 'Kelompok Ternak Sukses Makmur';
  static const _jumlahTernak = 24;
  static const _ternakSehat = 21;
  static const _ternakPerluCek = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopSection(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                ),
                child: Transform.translate(
                  offset: const Offset(0, -30),
                  child: KelompokCard(
                    namaKelompok: _namaKelompok,
                    jumlahTernak: _jumlahTernak,
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                ),
                child: Column(
                  children: [
                    // Stat card hijau — Ternak Sehat
                    DashboardStatCard(
                      title: '$_ternakSehat Ternak Sehat!',
                      subtitle: 'Lihat grafik kesehatan ternak disini!',
                      ctaLabel: 'Lihat Grafik',
                      overlayColor: AppColors.cardSehat,
                      backgroundImage: AppConstants.cardSehatTidak,
                      imageAlignment: const Alignment(1.0, 0.3),
                      imageScale: 1.5,
                      iconAsset: AppConstants.iconLoveSehat,
                      fallbackIcon: Icons.favorite_rounded,
                      onCtaTap: () {},
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Stat card merah — Ternak Perlu Dicek
                    // Height 109 = 95 × 1.15 (user request: besarkan 15% lagi)
                    DashboardStatCard(
                      title: '$_ternakPerluCek Ternak Perlu Dicek!',
                      subtitle:
                          'Ternak alami diare, pastikan beri\npenanganan yang tepat',
                      ctaLabel: 'Cek Sekarang',
                      overlayColor: AppColors.cardPerluCek,
                      backgroundImage: AppConstants.cardSehatTidak,
                      // ⚠️ ADJUST POSISI SAPI DI SINI ⚠️
                      // Format: Alignment(x, y)
                      //   x: -1.0 (kiri) → 0 (tengah) → 1.0 (kanan)
                      //   y: -1.0 (atas) → 0 (tengah) → 1.0 (bawah)
                      imageAlignment: const Alignment(1.0, 0.3),
                      // ⚠️ ZOOM SAPI DI SINI ⚠️
                      // 1.0 = original, 1.5 = zoom 50%, 2.0 = zoom 100%
                      imageScale: 1.5,
                      iconAsset: AppConstants.iconSeruDicek,
                      fallbackIcon: Icons.warning_rounded,
                      height: 109,
                      onCtaTap: () {},
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const ProduksiCard(
                      totalLiter: 24.6,
                      layakLiter: 20.0,
                      tidakLayakLiter: 4.6,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AktivitasHariIniCard(
                      onSeeAll: () {},
                      items: [
                        AktivitasItem(
                          icon: Icons.vaccines_outlined,
                          iconAsset: AppConstants.iconVaksinasiTernak,
                          title: 'Vaksinasi Ternak',
                          subtitle: 'Pukul 10.00',
                          subtitleColor: AppColors.error,
                          onTap: () {},
                        ),
                        AktivitasItem(
                          icon: Icons.inventory_2_outlined,
                          iconAsset: AppConstants.iconKonfirmasiBantuan,
                          title: 'Konfirmasi Bantuan',
                          subtitle: 'Segera konfirmasi',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
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
        AppSpacing.huge,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        'Halo, $_namaUser!',
                        style: AppTypography.headingLarge.copyWith(
                          color: AppColors.textOnPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Apa yang ingin kamu cek hari ini?',
                  style: AppTypography.subtitleOnPrimary.copyWith(
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _NotificationBell(onTap: () {}, hasUnread: true),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasUnread;

  const _NotificationBell({required this.onTap, this.hasUnread = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.cream.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.textOnPrimary,
                size: 22,
              ),
              if (hasUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
