import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_size.dart';
import '../../../../core/theme/app_typography.dart';
import '../../providers/produksi_provider.dart';
import '../widgets/grafik_produksi_chart.dart';

/// Sub-tab: Produksi — Catatan Produksi + Bulan Ini + Grafik
class TabProduksi extends ConsumerStatefulWidget {
  const TabProduksi({super.key});

  @override
  ConsumerState<TabProduksi> createState() => _TabProduksiState();
}

class _TabProduksiState extends ConsumerState<TabProduksi> {
  bool _isMingguan = true;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(produksiStatsProvider);
    final mingguan = ref.watch(produksiMingguanProvider);
    final bulanan = ref.watch(produksiBulananProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSize.screenPaddingH,
        AppSize.md,
        AppSize.screenPaddingH,
        100.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeaderRow(
            title: 'Catatan Produksi',
            onTambah: () => context.push('/ternak/input-produksi'),
          ),
          SizedBox(height: AppSize.sm),
          _HariIniCard(stats: stats),
          SizedBox(height: AppSize.sm),
          _BulanIniCard(stats: stats),
          SizedBox(height: AppSize.sm),
          _GrafikProduksiCard(
            isMingguan: _isMingguan,
            onToggle: (v) => setState(() => _isMingguan = v),
            data: _isMingguan ? mingguan : bulanan,
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback onTambah;

  const _HeaderRow({required this.title, required this.onTambah});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.textDarker,
            fontWeight: FontWeight.w700,
            fontSize: AppSize.fs15,
          ),
        ),
        Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onTambah,
            borderRadius: BorderRadius.circular(AppSize.rXl),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.sm + 2,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSize.rXl),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: AppColors.white, size: AppSize.fs14),
                  SizedBox(width: 3.w),
                  Text(
                    'Tambah',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppSize.fs12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HariIniCard extends StatelessWidget {
  final ProduksiStats stats;

  const _HariIniCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.rCard),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hari Ini',
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.textDarker,
                  fontWeight: FontWeight.w800,
                  fontSize: AppSize.fs14,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.pets_rounded,
                      color: AppColors.primary, size: AppSize.iconMd),
                  SizedBox(width: 4.w),
                  Text(
                    '${stats.sapiAktif + 9}', // Dummy jumlah total ternak
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w800,
                      fontSize: AppSize.fs16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSize.sm),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  value: '${stats.literHariIni.toStringAsFixed(0)}',
                  label: 'Liter',
                  icon: Icons.local_drink_outlined,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _StatBox(
                  value: '${stats.sapiAktif}',
                  label: 'Sapi',
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: _StatBox(
                  value: 'Hari Ini',
                  label: 'Panen',
                  small: true,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.sm),
          SizedBox(
            width: double.infinity,
            height: 42.h,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lihat Detail Produksi — coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.rButton),
                ),
              ),
              child: Text(
                'Lihat Detail Produksi',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: AppSize.fs13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final bool small;

  const _StatBox({
    required this.value,
    required this.label,
    this.icon,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSize.rButton),
      ),
      child: Column(
        children: [
          if (icon != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: AppSize.fs14),
                SizedBox(width: 4.w),
                Text(
                  value,
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: small ? AppSize.fs12 : AppSize.fs15,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: small ? AppSize.fs12 : AppSize.fs15,
              ),
            ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: AppSize.fs10,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulanIniCard extends StatelessWidget {
  final ProduksiStats stats;

  const _BulanIniCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.md),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppSize.rCard),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bulan Ini',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w800,
                    fontSize: AppSize.fs14,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  stats.namaBulan,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: AppSize.fs12,
                  ),
                ),
                Text(
                  '${stats.literBulanIni.toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                        (m) => '${m[1]},',
                      )} Liter',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.fs13,
                  ),
                ),
              ],
            ),
          ),
          // Ilustrasi botol susu
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSize.rMd),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.local_drink_rounded,
              color: AppColors.primary,
              size: AppSize.iconXl,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrafikProduksiCard extends StatelessWidget {
  final bool isMingguan;
  final ValueChanged<bool> onToggle;
  final List<ProduksiPoint> data;

  const _GrafikProduksiCard({
    required this.isMingguan,
    required this.onToggle,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.rCard),
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
            'Grafik Produksi',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: AppSize.fs13,
            ),
          ),
          SizedBox(height: AppSize.sm),
          GrafikProduksiChart(data: data),
          SizedBox(height: AppSize.sm),
          // Toggle Mingguan / Bulanan
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TogglePill(
                label: 'Mingguan',
                color: const Color(0xFF7C9A6F),
                active: isMingguan,
                onTap: () => onToggle(true),
              ),
              SizedBox(width: AppSize.sm),
              _TogglePill(
                label: 'Bulanan',
                color: const Color(0xFFE8B93C),
                active: !isMingguan,
                onTap: () => onToggle(false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  const _TogglePill({
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.rXl),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.sm,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: active ? color : color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSize.rXl),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: active ? AppColors.white : color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: active ? AppColors.white : AppColors.textDark,
                  fontSize: AppSize.fs11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// flutter_screenutil extensions provide `.w` / `.h` / `.sp` / `.r`
// directly on num values (e.g. `16.w`, `14.sp`, `8.r`).
