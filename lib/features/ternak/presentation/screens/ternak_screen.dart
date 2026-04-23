import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/animations/fade_slide_in.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class TernakScreen extends ConsumerStatefulWidget {
  const TernakScreen({super.key});

  @override
  ConsumerState<TernakScreen> createState() => _TernakScreenState();
}

class _TernakScreenState extends ConsumerState<TernakScreen> {
  int _tabIndex = 0;
  final _tabs = ['Ternak', 'Kesehatan', 'Produksi'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header brown
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Ternak',
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _SearchField(),
                const SizedBox(height: AppSpacing.md),
                _TabBar(
                  tabs: _tabs,
                  activeIndex: _tabIndex,
                  onTap: (i) => setState(() => _tabIndex = i),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                FadeSlideIn(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _tabIndex == 0
                            ? 'Data Kandang'
                            : _tabIndex == 1
                                ? 'Kesehatan Kandang'
                                : 'Produksi Kandang',
                        style: AppTypography.headingMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          '+ Tambah',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                StaggeredList(
                  baseDelay: const Duration(milliseconds: 200),
                  children: [
                    _KandangCard(
                      name: 'Kandang Sapi A',
                      subtitle: 'Sapi Perah Holstein',
                      trailing: '10,5 L',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _KandangCard(
                      name: 'Kandang Sapi B',
                      subtitle: 'Sapi Perah Holstein',
                      trailing: '10,5 L',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari ternak',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final List<String> tabs;
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _TabBar({
    required this.tabs,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tabs.length, (i) {
        final isActive = i == activeIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.secondary
                    : AppColors.textOnPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                tabs[i],
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _KandangCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String trailing;

  const _KandangCard({
    required this.name,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.backgroundAlt,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.pets, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            trailing,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
