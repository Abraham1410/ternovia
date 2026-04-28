import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/info_panel.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/kelompok_form_provider.dart';
import 'step_indicator.dart';

class BuatKelompokForm extends ConsumerWidget {
  const BuatKelompokForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(kelompokFormProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoPanel(
            message:
                'Lengkapi data berikut untuk memulai pengelolaan kelompok di Ternovia.',
          ),
          const SizedBox(height: AppSpacing.lg),
          StepIndicator(
            currentStep: formState.currentStep,
            labels: const [
              'Informasi\nKelompok',
              'Lokasi\nTernak',
              'Data Ketua\nKelompok',
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildStepContent(formState.currentStep),
          const SizedBox(height: AppSpacing.xl),
          _buildActionButtons(context, ref, formState.currentStep),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 1:
        return _Step1InformasiKelompok();
      case 2:
        return _Step2LokasiTernak();
      case 3:
        return _Step3DataKetua();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons(
      BuildContext context, WidgetRef ref, int step) {
    final notifier = ref.read(kelompokFormProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: 'Kembali',
            onPressed: () {
              if (step == 1) {
                context.go('/pilih-peran');
              } else {
                notifier.prevStep();
              }
            },
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: PrimaryButton(
            label: step < 3 ? 'Lanjutkan' : 'Buat Kelompok',
            onPressed: () {
              // Validation per step — return spesifik error message
              String? errorMsg;
              if (step == 1) errorMsg = notifier.validateStep1();
              if (step == 2) errorMsg = notifier.validateStep2();
              if (step == 3) errorMsg = notifier.validateStep3();

              if (errorMsg != null) {
                _showErrorSnackbar(context, errorMsg);
                return;
              }

              if (step < 3) {
                notifier.nextStep();
              } else {
                _submitForm(context, ref);
              }
            },
          ),
        ),
      ],
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

  void _submitForm(BuildContext context, WidgetRef ref) {
    // Generate sample code dari timestamp. Nanti ini dari backend.
    final now = DateTime.now().millisecondsSinceEpoch;
    final suffix = (now % 100000).toString().padLeft(5, '0');
    final kode = 'TN-$suffix';

    // Reset form state biar clean
    ref.read(kelompokFormProvider.notifier).reset();

    // Redirect ke kelompok-berhasil screen
    context.go('/kelompok-berhasil?kode=$kode');
  }
}

// ==================== STEP 1 ====================
class _Step1InformasiKelompok extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Step1InformasiKelompok> createState() =>
      _Step1InformasiKelompokState();
}

class _Step1InformasiKelompokState
    extends ConsumerState<_Step1InformasiKelompok> {
  late TextEditingController _namaController;
  late TextEditingController _jumlahAnggotaController;
  late TextEditingController _jumlahTernakController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(kelompokFormProvider);
    _namaController = TextEditingController(text: state.namaKelompok);
    _jumlahAnggotaController =
        TextEditingController(text: state.jumlahAnggotaAwal);
    _jumlahTernakController =
        TextEditingController(text: state.jumlahTernak);
    _deskripsiController = TextEditingController(text: state.deskripsi);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahAnggotaController.dispose();
    _jumlahTernakController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(kelompokFormProvider.notifier);
    final state = ref.watch(kelompokFormProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Nama Kelompok',
            hint: 'cth: Kelompok Tenak Sukses Makmur',
            controller: _namaController,
            onChanged: notifier.setNamaKelompok,
          ),
          const SizedBox(height: AppSpacing.md),
          AppDropdownField<JenisTernak>(
            label: 'Jenis Ternak',
            hint: 'Jenis Ternak',
            value: state.jenisTernak,
            items: JenisTernak.values
                .map((j) => DropdownMenuItem(
                      value: j,
                      child: Text(j.label),
                    ))
                .toList(),
            onChanged: notifier.setJenisTernak,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Jumlah Anggota Awal',
            hint: 'cth: 9',
            controller: _jumlahAnggotaController,
            keyboardType: TextInputType.number,
            onChanged: notifier.setJumlahAnggotaAwal,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Jumlah Ternak Saat Ini',
            hint: 'cth: 30',
            controller: _jumlahTernakController,
            keyboardType: TextInputType.number,
            onChanged: notifier.setJumlahTernak,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Deskripsi Singkat Kelompok',
            hint: 'cth: Fokus pada penggemukan sapi potong',
            controller: _deskripsiController,
            maxLines: 3,
            onChanged: notifier.setDeskripsi,
          ),
        ],
      ),
    );
  }
}

// ==================== STEP 2 ====================
class _Step2LokasiTernak extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Step2LokasiTernak> createState() =>
      _Step2LokasiTernakState();
}

class _Step2LokasiTernakState extends ConsumerState<_Step2LokasiTernak> {
  late TextEditingController _provinsiC;
  late TextEditingController _kabupatenC;
  late TextEditingController _kecamatanC;
  late TextEditingController _desaC;
  late TextEditingController _alamatC;

  @override
  void initState() {
    super.initState();
    final state = ref.read(kelompokFormProvider);
    _provinsiC = TextEditingController(text: state.provinsi);
    _kabupatenC = TextEditingController(text: state.kabupaten);
    _kecamatanC = TextEditingController(text: state.kecamatan);
    _desaC = TextEditingController(text: state.desa);
    _alamatC = TextEditingController(text: state.alamatLengkap);
  }

  @override
  void dispose() {
    _provinsiC.dispose();
    _kabupatenC.dispose();
    _kecamatanC.dispose();
    _desaC.dispose();
    _alamatC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(kelompokFormProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Provinsi',
            hint: 'Masukkan Provinsi',
            controller: _provinsiC,
            onChanged: notifier.setProvinsi,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Kabupaten / Kota',
            hint: 'Masukkan Kabupaten / Kota',
            controller: _kabupatenC,
            onChanged: notifier.setKabupaten,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Kecamatan',
            hint: 'Masukkan Kecamatan',
            controller: _kecamatanC,
            onChanged: notifier.setKecamatan,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Desa',
            hint: 'Masukkan Desa',
            controller: _desaC,
            onChanged: notifier.setDesa,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Alamat Lengkap',
            hint: 'Masukkan Alamat Lengkap',
            controller: _alamatC,
            maxLines: 3,
            onChanged: notifier.setAlamatLengkap,
          ),
        ],
      ),
    );
  }
}

// ==================== STEP 3 ====================
class _Step3DataKetua extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Step3DataKetua> createState() => _Step3DataKetuaState();
}

class _Step3DataKetuaState extends ConsumerState<_Step3DataKetua> {
  late TextEditingController _namaC;
  late TextEditingController _nikC;
  late TextEditingController _telpC;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final state = ref.read(kelompokFormProvider);
    _namaC = TextEditingController(text: state.namaKetua);
    _nikC = TextEditingController(text: state.nik);
    _telpC = TextEditingController(text: state.noTelepon);
  }

  @override
  void dispose() {
    _namaC.dispose();
    _nikC.dispose();
    _telpC.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        ref
            .read(kelompokFormProvider.notifier)
            .setFotoKetua(picked.path);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showPhotoPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Pilih Foto',
                style: AppTypography.headingMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              _PhotoSourceOption(
                icon: Icons.camera_alt_outlined,
                label: 'Ambil dari Kamera',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              _PhotoSourceOption(
                icon: Icons.photo_library_outlined,
                label: 'Pilih dari Galeri',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
              // Option to remove existing photo
              if (ref.read(kelompokFormProvider).fotoKetuaPath != null) ...[
                const SizedBox(height: AppSpacing.xs),
                _PhotoSourceOption(
                  icon: Icons.delete_outline,
                  label: 'Hapus Foto',
                  iconColor: AppColors.error,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    ref
                        .read(kelompokFormProvider.notifier)
                        .setFotoKetua(null);
                  },
                ),
              ],
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(kelompokFormProvider.notifier);
    final fotoPath = ref.watch(
      kelompokFormProvider.select((s) => s.fotoKetuaPath),
    );

    return Column(
      children: [
        _buildAvatarPicker(fotoPath),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.infoBg.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Nama Ketua Kelompok',
                hint: 'Nama Ketua Kelompok',
                controller: _namaC,
                onChanged: notifier.setNamaKetua,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'NIK',
                hint: 'cth: 3517111xxxxxxxxx (16 digit)',
                controller: _nikC,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: notifier.setNik,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'No. Telepon',
                      hint: 'cth: 085648xxxxx',
                      controller: _telpC,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                      onChanged: notifier.setNoTelepon,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _buildPeranField()),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _buildSecurityNotice(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarPicker(String? fotoPath) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showPhotoPickerSheet,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              image: fotoPath != null
                  ? DecorationImage(
                      image: FileImage(File(fotoPath)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                if (fotoPath == null)
                  const Center(
                    child: Icon(
                      Icons.person,
                      size: 52,
                      color: AppColors.cream,
                    ),
                  ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cream,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: AppColors.cream,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextButton(
          onPressed: _showPhotoPickerSheet,
          style: TextButton.styleFrom(
            backgroundColor: AppColors.cream,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
              side: const BorderSide(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
          ),
          child: Text(
            fotoPath == null ? 'Tambah Foto' : 'Ubah Foto',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildPeranField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Peran',
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.textDarker,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          height: AppDimensions.inputHeight,
          decoration: BoxDecoration(
            color: AppColors.cream,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Ketua Kelompok',
                  style: AppTypography.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.lock_outline,
                size: 16,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined,
              size: 18, color: AppColors.success),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Tenang, semua data ketua kamu aman dan tidak akan dibagikan ke sembarang orang.',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _PhotoSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.infoBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: AppTypography.bodyLarge.copyWith(
                  color: iconColor ?? AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
