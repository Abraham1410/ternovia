import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/kandang_provider.dart';
import 'tabs/tab_kesehatan.dart';
import 'tabs/tab_produksi.dart';
import 'tabs/tab_ternak.dart';

/// Tab Ternak shell — header coklat + search bar + 3 sub-tab pill.
/// Content di bawah header ganti sesuai sub-tab yang aktif.
class TernakListScreen extends ConsumerStatefulWidget {
  const TernakListScreen({super.key});

  @override
  ConsumerState<TernakListScreen> createState() =>
      _TernakListScreenState();
}

class _TernakListScreenState extends ConsumerState<TernakListScreen> {
  int _activeTab = 0; // 0=Ternak, 1=Kesehatan, 2=Produksi
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
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Coklat background
        Container(
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
            AppSpacing.xl + 8,
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Ternak',
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildSearchBar(),
            ],
          ),
        ),
        // Sub-tab pill — overlap ke body
        Positioned(
          bottom: -18,
          left: 0,
          right: 0,
          child: Center(child: _buildSubTabs()),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textMuted, size: 20),
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
                // Force putih biar konsisten sama icon area — fix belang cream+putih
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
              onChanged: (v) {
                ref.read(kandangSearchProvider.notifier).state = v;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabPill(
            label: 'Ternak',
            isActive: _activeTab == 0,
            onTap: () => setState(() => _activeTab = 0),
          ),
          _TabPill(
            label: 'Kesehatan',
            isActive: _activeTab == 1,
            onTap: () => setState(() => _activeTab = 1),
          ),
          _TabPill(
            label: 'Produksi',
            isActive: _activeTab == 2,
            onTap: () => setState(() => _activeTab = 2),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: IndexedStack(
        index: _activeTab,
        children: const [
          TabTernak(),
          TabKesehatan(),
          TabProduksi(),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isActive ? AppColors.white : AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
