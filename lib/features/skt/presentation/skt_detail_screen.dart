import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/skt_pdf_generator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/info_panel.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../providers/skt_form_provider.dart';
import '../providers/skt_form_state.dart';

/// Detail screen untuk riwayat pengajuan SKT.
/// Menampilkan:
/// - Status pengajuan (badge hijau / oranye)
/// - Card ringkasan kelompok
/// - Timeline steps (Diajukan, Peninjauan, Validasi, Pembuatan, Selesai)
/// - Download SKT PDF (kalau status Selesai)
class SktDetailScreen extends ConsumerWidget {
  final String pengajuanId;

  const SktDetailScreen({super.key, required this.pengajuanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riwayat = ref.watch(sktRiwayatProvider);
    final pengajuan = riwayat.firstWhere(
      (p) => p.id == pengajuanId,
      orElse: () => SktPengajuan(
        id: pengajuanId,
        namaKelompok: 'Pengajuan SKT',
        jumlahDokumen: 8,
        tanggalKirim: DateTime(2026, 1, 2),
        status: SktStatus.prosesValidasi,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Detail Pengajuan SKT',
            onBackPressed: () => context.go('/layanan/skt'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderRow(pengajuan),
                  const SizedBox(height: AppSpacing.md),
                  _buildSummaryCard(),
                  const SizedBox(height: AppSpacing.md),
                  _buildStatusInfoPanel(pengajuan.status),
                  const SizedBox(height: AppSpacing.md),
                  _buildTimelineCard(pengajuan.status),
                  const SizedBox(height: AppSpacing.md),
                  // Revision card — tampil kalau status = perluRevisi
                  if (pengajuan.status == SktStatus.perluRevisi &&
                      pengajuan.revisionNotes != null &&
                      pengajuan.revisionNotes!.isNotEmpty) ...[
                    _RevisionCard(
                      onRevisiTap: () =>
                          _startRevision(context, ref, pengajuan),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (pengajuan.status == SktStatus.selesai) ...[
                    const InfoPanel(
                      message:
                          'Pengajuan SKT Anda telah selesai diproses. Surat Keterangan Terdaftar (SKT) dapat diunduh melalui dokumen di bawah.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildDownloadCard(context, pengajuan),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startRevision(
    BuildContext context,
    WidgetRef ref,
    SktPengajuan pengajuan,
  ) {
    // Convert RevisionNote list → Map<dokumenCode, catatan>
    final notesMap = <String, String>{};
    for (final note in pengajuan.revisionNotes!) {
      notesMap[note.dokumenCode] = note.catatan;
    }

    // Dummy existing dokumenFiles — semua dokumen anggap udah di-upload
    // di pengajuan asli, kecuali yang perlu direvisi
    final existingFiles = <String, DokumenFile>{
      'surat_permohonan': const DokumenFile(
        path: '/tmp/dummy_surat.pdf',
        name: 'Surat_Permohonan.pdf',
        sizeBytes: 248000,
      ),
      'susunan_pengurus': const DokumenFile(
        path: '/tmp/dummy_susunan.pdf',
        name: 'Susunan_Pengurus.pdf',
        sizeBytes: 156000,
      ),
      'ktp_anggota': const DokumenFile(
        path: '/tmp/dummy_ktp.pdf',
        name: 'KTP_Anggota.pdf',
        sizeBytes: 892000,
      ),
      'kk_anggota': const DokumenFile(
        path: '/tmp/dummy_kk.pdf',
        name: 'KK_Anggota.pdf',
        sizeBytes: 445000,
      ),
      'berita_acara': const DokumenFile(
        path: '/tmp/dummy_berita.pdf',
        name: 'Berita_Acara.pdf',
        sizeBytes: 312000,
      ),
      'daftar_hadir': const DokumenFile(
        path: '/tmp/dummy_daftar.pdf',
        name: 'Daftar_Hadir.pdf',
        sizeBytes: 128000,
      ),
    };

    ref.read(sktFormProvider.notifier).startRevision(
          pengajuanId: pengajuan.id,
          revisionNotes: notesMap,
          existingDokumenFiles: existingFiles,
        );

    context.push('/layanan/skt/form');
  }

  Widget _buildHeaderRow(SktPengajuan p) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Pengajuan SKT',
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _StatusBadge(status: p.status),
      ],
    );
  }

  Widget _buildSummaryCard() {
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
            'Kelompok Ternak Sukses Makmur',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Dusun Suko, Desa Sukolilo, Jombang,\nJawa Timur',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textDark,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Kelompok Ternak Sapi Perah',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '24 Sapi',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfoPanel(SktStatus status) {
    String msg;
    switch (status) {
      case SktStatus.selesai:
        msg = 'Pengajuan SKT Anda telah selesai diproses.';
        break;
      case SktStatus.perluRevisi:
        msg =
            'Pengajuan Anda memerlukan revisi. Mohon perbaiki dokumen sesuai catatan petugas di bawah.';
        break;
      case SktStatus.prosesValidasi:
      case SktStatus.peninjauan:
      case SktStatus.pembuatan:
        msg =
            'Pengajuan SKT kelompok ternak Anda sedang diproses. Estimasi penyelesaian 2–3 hari kerja.';
        break;
      case SktStatus.diajukan:
        msg = 'Pengajuan Anda telah diterima dan akan segera ditinjau.';
        break;
      case SktStatus.draft:
        msg = 'Draft belum dikirim.';
        break;
    }
    return InfoPanel(message: msg);
  }

  Widget _buildTimelineCard(SktStatus currentStatus) {
    final steps = _TimelineStep.allSteps();
    final currentIdx = _currentStepIndex(currentStatus);

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
        children: List.generate(steps.length, (i) {
          final step = steps[i];
          final isDone = i <= currentIdx;
          final isLast = i == steps.length - 1;
          return _TimelineRow(
            label: step.label,
            date: step.dummyDate,
            isDone: isDone,
            isLast: isLast,
          );
        }),
      ),
    );
  }

  Widget _buildDownloadCard(BuildContext context, SktPengajuan pengajuan) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => _downloadPdf(context, pengajuan),
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SKT Kel. Ternak SM (PDF)',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Tap untuk download & bagikan',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.download_rounded,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadPdf(
    BuildContext context,
    SktPengajuan pengajuan,
  ) async {
    // Loading dialog — generate PDF bisa perlu beberapa saat
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Menyiapkan PDF SKT...',
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final filePath = await SktPdfGenerator.generate(
        pengajuan: pengajuan,
      );

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // close loading

      // Share sheet → user bisa save to Downloads, share to WA, email, dll
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Surat Keterangan Terdaftar',
        text: 'SKT Kelompok Ternak Sukses Makmur',
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal generate PDF: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  int _currentStepIndex(SktStatus status) {
    switch (status) {
      case SktStatus.draft:
        return -1;
      case SktStatus.diajukan:
        return 0;
      case SktStatus.peninjauan:
        return 1;
      case SktStatus.perluRevisi:
        // Revisi = stuck di peninjauan, belum lanjut
        return 1;
      case SktStatus.prosesValidasi:
        return 2;
      case SktStatus.pembuatan:
        return 3;
      case SktStatus.selesai:
        return 4;
    }
  }
}

class _TimelineStep {
  final String label;
  final String dummyDate;

  const _TimelineStep({required this.label, required this.dummyDate});

  static List<_TimelineStep> allSteps() => const [
        _TimelineStep(label: 'Diajukan', dummyDate: '02 Jan 2026'),
        _TimelineStep(
            label: 'Peninjauan Berkas', dummyDate: '04 Jan 2026'),
        _TimelineStep(label: 'Validasi Isi', dummyDate: '04 Jan 2026'),
        _TimelineStep(
            label: 'Pembuatan Surat SKT', dummyDate: '06 Jan 2026'),
        _TimelineStep(label: 'Selesai', dummyDate: '06 Jan 2026'),
      ];
}

class _TimelineRow extends StatelessWidget {
  final String label;
  final String date;
  final bool isDone;
  final bool isLast;

  const _TimelineRow({
    required this.label,
    required this.date,
    required this.isDone,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        isDone ? AppColors.success : AppColors.textMuted.withValues(alpha: 0.5);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                isDone
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 22,
                color: iconColor,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone
                        ? AppColors.success
                        : AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.labelLarge.copyWith(
                        color: isDone
                            ? AppColors.textDarker
                            : AppColors.textMuted,
                        fontWeight: isDone
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    date,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
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

class _StatusBadge extends StatelessWidget {
  final SktStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    switch (status) {
      case SktStatus.selesai:
        bg = AppColors.success;
        break;
      case SktStatus.perluRevisi:
        bg = AppColors.error;
        break;
      case SktStatus.prosesValidasi:
      case SktStatus.peninjauan:
      case SktStatus.pembuatan:
      case SktStatus.diajukan:
        bg = AppColors.warning;
        break;
      case SktStatus.draft:
        bg = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Text(
        status.shortLabel,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Card yang tampil khusus untuk status perluRevisi.
/// Berisi:
/// - Header "Catatan Revisi Petugas" dengan tanggal
/// - List dokumen yang perlu diperbaiki + catatan petugas per dokumen
/// - Button "Revisi Sekarang"
class _RevisionCard extends StatelessWidget {
  final VoidCallback onRevisiTap;

  const _RevisionCard({
    required this.onRevisiTap,
  });

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
          // Title plain "Catatan Revisi" — no icon, no date (Figma match)
          Text(
            'Catatan Revisi',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          // Subtitle deskriptif
          Text(
            'Beberapa data perlu diperbaiki sesuai perintah agar pengajuan '
            'dapat diproses kembali oleh dinas.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textDark,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Cream box with warning bullets — match Figma persis
          // (text hardcoded sesuai design, bukan dari data backend)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFAEFDF),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _RevisionBulletItem(
                    text: 'Surat pemohon belum ditandantangani ketua'),
                _RevisionBulletItem(
                    text: 'Jumlah ternak tidak sesuai dengan dokumen'),
                _RevisionBulletItem(text: 'Daftar hadir belum lengkap'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Button "Perbaiki Data" — solid coklat full width, no icon
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onRevisiTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                elevation: 0,
              ),
              child: Text(
                'Perbaiki Data',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single bullet warning item with orange triangle icon — used inside
/// the cream box of [_RevisionCard].
class _RevisionBulletItem extends StatelessWidget {
  final String text;

  const _RevisionBulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textDark,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
