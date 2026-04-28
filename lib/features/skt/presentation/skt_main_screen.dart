import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/expandable_card.dart';
import '../../../shared/widgets/info_panel.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../content/guide_content.dart';
import '../providers/skt_form_provider.dart';
import '../providers/skt_form_state.dart';
import '../widgets/guide_sections_view.dart';

class SktMainScreen extends ConsumerWidget {
  const SktMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drafts = ref.watch(sktDraftProvider);
    final riwayat = ref.watch(sktRiwayatProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Pengajuan SKT',
            onBackPressed: () => context.go('/dashboard?tab=2'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPaddingH,
                AppSpacing.lg,
                AppDimensions.screenPaddingH,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // CTA utama
                  PrimaryButton(
                    label: '+ Mulai Pengajuan Baru',
                    onPressed: () {
                      // Reset form state + go to step 1
                      ref.read(sktFormProvider.notifier).reset();
                      context.push('/layanan/skt/form');
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Draft section
                  if (drafts.isNotEmpty) ...[
                    _SectionCard(
                      title: 'Draft Pengajuan SKT',
                      children: drafts
                          .map((d) => _DraftTile(
                                draft: d,
                                onLengkapi: () {
                                  ref
                                      .read(sktFormProvider.notifier)
                                      .loadFromDraft(d);
                                  context.push('/layanan/skt/form');
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Riwayat section
                  if (riwayat.isNotEmpty) ...[
                    _SectionCard(
                      title: 'Riwayat Pengajuan SKT',
                      children: riwayat
                          .map((r) => _RiwayatTile(
                                pengajuan: r,
                                onTap: () => context.push(
                                  '/layanan/skt/detail/${r.id}',
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Info panel
                  const InfoPanel(
                    message:
                        'Gunakan format resmi sesuai contoh. Pastikan file jelas, tidak terpotong, dan mudah dibaca.',
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Panduan sections — accordion (expand/collapse di hal yang sama)
                  ExpandableCard(
                    title: 'Panduan Pengajuan',
                    content: const GuideSectionsView(
                      sections: SktGuideContent.panduanPengajuan,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ExpandableCard(
                    title: 'Syarat & Ketentuan Pengajuan SKT',
                    content: const GuideSectionsView(
                      sections: SktGuideContent.syaratKetentuan,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ExpandableCard(
                    title: 'Contoh Dokumen Pengajuan SKT',
                    content: const GuideSectionsView(
                      sections: SktGuideContent.contohDokumen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

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
            title,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _DraftTile extends StatelessWidget {
  final SktDraft draft;
  final VoidCallback onLengkapi;

  const _DraftTile({
    required this.draft,
    required this.onLengkapi,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draft.namaKelompok,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tersimpan: ${_formatDate(draft.tanggalSimpan)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _PillButton(
            label: 'Lengkapi',
            onTap: onLengkapi,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _RiwayatTile extends StatelessWidget {
  final SktPengajuan pengajuan;
  final VoidCallback onTap;

  const _RiwayatTile({required this.pengajuan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pengajuan.namaKelompok,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textDarker,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.description_outlined,
                    size: 16, color: AppColors.textMuted),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Terkirim ${pengajuan.jumlahDokumen} Dokumen',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textDark,
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
                  _formatDate(pengajuan.tanggalKirim),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _StatusPill(status: pengajuan.status),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _StatusPill extends StatelessWidget {
  final SktStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    IconData icon;
    switch (status) {
      case SktStatus.selesai:
        bg = AppColors.success;
        icon = Icons.check_circle;
        break;
      case SktStatus.perluRevisi:
        bg = AppColors.error;
        icon = Icons.edit_note;
        break;
      case SktStatus.prosesValidasi:
      case SktStatus.peninjauan:
      case SktStatus.pembuatan:
      case SktStatus.diajukan:
        bg = AppColors.warning;
        icon = Icons.hourglass_empty;
        break;
      case SktStatus.draft:
        bg = AppColors.primary;
        icon = Icons.edit_note;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.white),
          const SizedBox(width: AppSpacing.xs),
          Text(
            status.shortLabel,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
