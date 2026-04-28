import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../dashboard/presentation/dashboard_screen.dart';
import '../layanan/presentation/layanan_screen.dart';
import '../profile/presentation/profile_screen.dart';
import '../ternak/presentation/ternak_list_screen.dart';

/// ShellScaffold — 5 tab bottom nav dengan FAB yang "travel" ngikut posisi tab aktif.
///
/// Pattern: setiap tab punya slot yang sama besar. Yang aktif → iconnya
/// di-hide (diganti spacer), lalu FAB bulet coklat muncul di atas slot
/// itu dengan icon yang sama, memberi efek "pop up / highlight" di posisi
/// tab aktif.
class ShellScaffold extends ConsumerStatefulWidget {
  final int initialTab;

  const ShellScaffold({
    super.key,
    this.initialTab = 0,
  });

  @override
  ConsumerState<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends ConsumerState<ShellScaffold> {
  late int _currentIndex;

  final List<_TabSpec> _tabs = const [
    _TabSpec(icon: Icons.home_rounded, label: 'Home'),
    _TabSpec(
      icon: Icons.pets_rounded, // fallback kalau asset gagal load
      label: 'Ternak',
      iconAsset: 'assets/icons/vaksinasi_ternak.png',
    ),
    _TabSpec(icon: Icons.article_rounded, label: 'Layanan'),
    _TabSpec(icon: Icons.menu_book_rounded, label: 'Edukasi'),
    _TabSpec(icon: Icons.person_outline_rounded, label: 'Profil'),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.clamp(0, _tabs.length - 1);
  }

  Widget _screenForIndex(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const TernakListScreen();
      case 2:
        return const LayananScreen();
      case 3:
        return const _PlaceholderTab(
          icon: Icons.menu_book_rounded,
          title: 'Edukasi',
          description:
              'Materi edukasi — artikel, video, tips peternakan.',
        );
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_tabs.length, _screenForIndex),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabCount = _tabs.length;
        final slotWidth = constraints.maxWidth / tabCount;

        // Posisi FAB = center dari slot tab aktif
        // FAB width = 56, so offset = (slotWidth - 56) / 2 dari kiri slot
        const fabSize = 56.0;
        final fabLeft = (slotWidth * _currentIndex) + (slotWidth - fabSize) / 2;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 72,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Row of regular tabs (active one renders as empty slot)
                  Row(
                    children: List.generate(tabCount, (i) {
                      return Expanded(child: _buildTabSlot(i));
                    }),
                  ),
                  // Traveling FAB — posisi dinamis ngikut tab aktif,
                  // overflow ~50% ke atas seperti design Figma
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    top: -28,
                    left: fabLeft,
                    child: _TravelingFab(
                      icon: _tabs[_currentIndex].icon,
                      iconAsset: _tabs[_currentIndex].iconAsset,
                      onTap: () {
                        // FAB di-tap → no-op (udah di tab ini)
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabSlot(int index) {
    final tab = _tabs[index];
    final isActive = _currentIndex == index;

    if (isActive) {
      // Slot tab aktif: icon dihide (FAB circle di atas yang jadi indikator),
      // tapi label tetap tampil di bawah biar user tau ini tab aktif (sesuai
      // Figma — Image 2 menunjukkan "Beranda" muncul di bawah FAB).
      // FAB circle 56px overflow -28px ke atas, jadi bottom edge FAB ada di
      // y=28 di dalam slot. Padding top 36 = label muncul di area aman.
      return SizedBox(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.only(top: 36),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              tab.label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pakai asset kalau ada, fallback ke IconData
          if (tab.iconAsset != null)
            SizedBox(
              width: 26,
              height: 26,
              child: Image.asset(
                tab.iconAsset!,
                color: AppColors.primary,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  tab.icon,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
            )
          else
            Icon(
              tab.icon,
              color: AppColors.primary,
              size: 26,
            ),
          const SizedBox(height: 4),
          Text(
            tab.label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSpec {
  final IconData icon;
  final String label;

  /// Optional asset path. Kalau ada, akan dipakai instead of [icon] (untuk
  /// FAB aktif). Jangan lupa daftarkan path ini di pubspec.yaml.
  final String? iconAsset;

  const _TabSpec({
    required this.icon,
    required this.label,
    this.iconAsset,
  });
}

class _TravelingFab extends StatelessWidget {
  final IconData icon;
  final String? iconAsset;
  final VoidCallback onTap;

  const _TravelingFab({
    required this.icon,
    required this.onTap,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: _buildIcon(),
          ),
        ),
      ),
    );
  }

  /// Render asset image kalau iconAsset ada, kalau gagal/null jatuh balik ke
  /// IconData. Pakai ColorFiltered dengan dstATop biar PNG monokrom otomatis
  /// jadi putih (sesuai design FAB white-on-brown).
  Widget _buildIcon() {
    if (iconAsset != null) {
      return Padding(
        // Sedikit padding biar gambar gak nempel ke edge circle
        key: ValueKey(iconAsset),
        padding: const EdgeInsets.all(14),
        child: Image.asset(
          iconAsset!,
          color: AppColors.white,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            icon,
            color: AppColors.white,
            size: 26,
          ),
        ),
      );
    }
    return Icon(
      icon,
      key: ValueKey(icon),
      color: AppColors.white,
      size: 26,
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 96,
                  color: AppColors.primary.withValues(alpha: 0.5)),
              const SizedBox(height: AppSpacing.md),
              Text(title,
                  style: AppTypography.headingLarge.copyWith(
                      color: AppColors.textDarker)),
              const SizedBox(height: AppSpacing.sm),
              Text(description,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textMuted)),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppRadius.button),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.construction,
                        color: AppColors.warning, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Coming soon',
                        style: AppTypography.labelMedium
                            .copyWith(color: AppColors.warning)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
