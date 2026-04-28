import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/info_panel.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../../../shared/widgets/submit_dialogs.dart';
import '../providers/skt_form_provider.dart';
import '../providers/skt_form_state.dart';
import '../widgets/skt_step_indicator.dart';
import 'skt_form_steps.dart';

class SktFormScreen extends ConsumerWidget {
  const SktFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sktFormProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: state.revisionMode
                ? 'Revisi Pengajuan SKT'
                : 'Mulai Pengajuan SKT',
            onBackPressed: () => _handleBack(context, ref),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoPanel(
                    message: state.currentStep == 5
                        ? 'Periksa kembali seluruh data sebelum mengirim pengajuan.'
                        : 'Gunakan format resmi sesuai contoh. Pastikan file jelas, tidak terpotong, dan mudah dibaca.',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Step indicator — 4 label, tapi step 5 = konfirmasi (visual ke-4 still)
                  SktStepIndicator(
                    currentStep: state.currentStep > 4
                        ? 4
                        : state.currentStep,
                    labels: const [
                      'Data\nKelompok',
                      'Data\nKetua',
                      'Data\nTernak',
                      'Dokumen\nPendukung',
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildCurrentStep(state.currentStep),
                  const SizedBox(height: AppSpacing.xl),
                  _buildActionButtons(context, ref),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(int step) {
    switch (step) {
      case 1:
        return const Step1DataKelompok();
      case 2:
        return const Step2DataKetua();
      case 3:
        return const Step3DataTernak();
      case 4:
        return const Step4Dokumentasi();
      case 5:
        return const Step5Konfirmasi();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final state = ref.read(sktFormProvider);

    final isLastStep = state.currentStep == 5;
    final label = isLastStep
        ? (state.revisionMode ? 'Kirim Revisi' : 'Kirim Pengajuan')
        : 'Lanjutkan';

    return Column(
      children: [
        // v30.5: Button "Simpan sebagai Draft" dihapus karena gak ada di
        // design Figma. Logic _saveDraft() dibiarkan untuk future use.
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Kembali',
                onPressed: () => _handleBack(context, ref),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: PrimaryButton(
                label: label,
                onPressed: () => _handleNext(context, ref),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _saveDraft(BuildContext context, WidgetRef ref) {
    final state = ref.read(sktFormProvider);
    final drafts = ref.read(sktDraftProvider);

    // Kalau state punya draftId (resume dari draft), update draft existing
    // Kalau gak ada, bikin draft baru
    final existingId = state.draftId;
    final draftId = existingId ??
        'draft_${DateTime.now().millisecondsSinceEpoch}';

    final namaKelompok = state.namaKelompok.isNotEmpty
        ? 'Draft ${state.namaKelompok}'
        : 'Draft Pengajuan SKT';

    final newDraft = SktDraft(
      id: draftId,
      namaKelompok: namaKelompok,
      tanggalSimpan: DateTime.now(),
      formState: state.copyWith(draftId: draftId),
    );

    // Replace kalau ada, tambah kalau baru
    final updated = existingId != null
        ? drafts.map((d) => d.id == existingId ? newDraft : d).toList()
        : [...drafts, newDraft];

    ref.read(sktDraftProvider.notifier).state = updated;

    // Update form state supaya pegang draftId (biar save lagi gak bikin duplicate)
    ref.read(sktFormProvider.notifier).state =
        state.copyWith(draftId: draftId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: AppColors.white, size: 20),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text('Draft tersimpan. Bisa dilanjutkan nanti.'),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBack(BuildContext context, WidgetRef ref) {
    final state = ref.read(sktFormProvider);
    if (state.currentStep == 1) {
      // Keluar dari form flow — kasih konfirmasi
      _showExitConfirm(context);
    } else {
      ref.read(sktFormProvider.notifier).prevStep();
    }
  }

  void _handleNext(BuildContext context, WidgetRef ref) {
    final state = ref.read(sktFormProvider);
    final notifier = ref.read(sktFormProvider.notifier);

    String? errorMsg;
    switch (state.currentStep) {
      case 1:
        errorMsg = notifier.validateStep1();
        break;
      case 2:
        errorMsg = notifier.validateStep2();
        break;
      case 3:
        errorMsg = notifier.validateStep3();
        break;
      case 4:
        errorMsg = notifier.validateStep4();
        break;
      case 5:
        // Submit — show konfirmasi dialog dulu
        _showSubmitConfirmation(context, ref);
        return;
    }

    if (errorMsg != null) {
      _showErrorSnackbar(context, errorMsg);
      return;
    }

    notifier.nextStep();
  }

  void _showExitConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Keluar dari pengajuan?',
          style: AppTypography.headingMedium,
        ),
        content: Text(
          'Data yang sudah kamu isi akan hilang jika tidak disimpan sebagai draft.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Lanjut Isi',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/layanan/skt');
            },
            child: Text(
              'Keluar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.cream),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  Future<void> _showSubmitConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await SubmitConfirmDialog.show(context);
    if (confirmed != true) return;
    if (!context.mounted) return;
    _submitPengajuan(context, ref);
  }

  void _submitPengajuan(BuildContext context, WidgetRef ref) {
    final state = ref.read(sktFormProvider);
    final isRevision = state.revisionMode;

    // Kalau revisi: update status pengajuan dari perluRevisi → peninjauan
    if (isRevision && state.pengajuanId != null) {
      final list = ref.read(sktRiwayatProvider);
      final updated = list.map((p) {
        if (p.id == state.pengajuanId) {
          return SktPengajuan(
            id: p.id,
            namaKelompok: p.namaKelompok,
            jumlahDokumen: p.jumlahDokumen,
            tanggalKirim: p.tanggalKirim,
            status: SktStatus.peninjauan,
            revisionNotes: null,
            tanggalRevisi: null,
          );
        }
        return p;
      }).toList();
      ref.read(sktRiwayatProvider.notifier).state = updated;
    }

    // Kalau bukan revisi dan ada draftId: hapus draft karena udah di-submit
    if (!isRevision && state.draftId != null) {
      final drafts = ref.read(sktDraftProvider);
      final filtered = drafts.where((d) => d.id != state.draftId).toList();
      ref.read(sktDraftProvider.notifier).state = filtered;
    }

    // Kalau pengajuan baru (bukan revisi): tambahin ke riwayat
    if (!isRevision) {
      final list = ref.read(sktRiwayatProvider);
      final newPengajuan = SktPengajuan(
        id: 'skt_${DateTime.now().millisecondsSinceEpoch}',
        namaKelompok: 'Pengajuan SKT',
        jumlahDokumen: state.dokumenFiles.length,
        tanggalKirim: DateTime.now(),
        status: SktStatus.diajukan,
      );
      ref.read(sktRiwayatProvider.notifier).state = [
        newPengajuan,
        ...list,
      ];
    }

    // Show success dialog — ilustrasi confetti + checkmark
    SubmitSuccessDialog.show(
      context,
      onClosed: () {
        ref.read(sktFormProvider.notifier).reset();
        context.go('/layanan/skt');
      },
    );
  }
}
