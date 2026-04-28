import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/ternovia_app_bar.dart';
import 'buat_kelompok_form.dart';
import 'gabung_kelompok_form.dart';

/// Screen utama untuk Peternak setelah pilih peran.
///
/// Menampilkan 2 tab:
/// - Buat Kelompok Baru → form multi-step (3 step)
/// - Gabung Kelompok → form dengan kode undangan
class KelompokScreen extends ConsumerStatefulWidget {
  final int initialTab;

  const KelompokScreen({
    super.key,
    this.initialTab = 0,
  });

  @override
  ConsumerState<KelompokScreen> createState() => _KelompokScreenState();
}

class _KelompokScreenState extends ConsumerState<KelompokScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          TernoviaAppBar(
            onBackPressed: () => context.go('/pilih-peran'),
          ),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                BuatKelompokForm(),
                GabungKelompokForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.cream,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelColor: AppColors.textDarker,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: AppTypography.headingSmall.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        dividerColor: AppColors.divider,
        tabs: const [
          Tab(
            height: 52,
            text: 'Buat Kelompok Baru',
          ),
          Tab(
            height: 52,
            text: 'Gabung Kelompok',
          ),
        ],
      ),
    );
  }
}
