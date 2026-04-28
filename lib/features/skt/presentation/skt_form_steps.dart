import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/file_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../providers/skt_form_provider.dart';
import '../providers/skt_form_state.dart';

// ====================== STEP 1 — Data Kelompok ======================

class Step1DataKelompok extends ConsumerStatefulWidget {
  const Step1DataKelompok({super.key});

  @override
  ConsumerState<Step1DataKelompok> createState() =>
      _Step1DataKelompokState();
}

class _Step1DataKelompokState extends ConsumerState<Step1DataKelompok> {
  late TextEditingController _alamatC;
  late TextEditingController _desaKecC;
  late TextEditingController _kabupatenC;
  late TextEditingController _provinsiC;

  @override
  void initState() {
    super.initState();
    final s = ref.read(sktFormProvider);
    _alamatC = TextEditingController(text: s.alamatKelompok);
    _desaKecC = TextEditingController(text: s.desaKecamatan);
    _kabupatenC = TextEditingController(text: s.kabupaten);
    _provinsiC = TextEditingController(text: s.provinsi);
  }

  @override
  void dispose() {
    _alamatC.dispose();
    _desaKecC.dispose();
    _kabupatenC.dispose();
    _provinsiC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = ref.read(sktFormProvider.notifier);
    final namaKelompok = ref.watch(
        sktFormProvider.select((s) => s.namaKelompok));

    return _StepContainer(
      title: '1. Data Kelompok',
      children: [
        _KelompokNamePill(name: namaKelompok),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Alamat Kelompok',
          hint: 'cth: Dusun Suko, Desa Sukolilo',
          controller: _alamatC,
          onChanged: n.setAlamatKelompok,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Desa / Kecamatan',
          hint: 'cth: Desa Sukolilo, Kec. Jombang',
          controller: _desaKecC,
          onChanged: n.setDesaKecamatan,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Kabupaten',
          hint: 'cth: Jombang',
          controller: _kabupatenC,
          onChanged: n.setKabupaten,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Provinsi',
          hint: 'cth: Jawa Timur',
          controller: _provinsiC,
          onChanged: n.setProvinsi,
        ),
      ],
    );
  }
}

// ====================== STEP 2 — Data Ketua ======================

class Step2DataKetua extends ConsumerStatefulWidget {
  const Step2DataKetua({super.key});

  @override
  ConsumerState<Step2DataKetua> createState() => _Step2DataKetuaState();
}

class _Step2DataKetuaState extends ConsumerState<Step2DataKetua> {
  late TextEditingController _namaC;
  late TextEditingController _hpC;
  late TextEditingController _nikC;
  late TextEditingController _anggotaC;

  @override
  void initState() {
    super.initState();
    final s = ref.read(sktFormProvider);
    _namaC = TextEditingController(text: s.namaKetua);
    _hpC = TextEditingController(text: s.nomorHp);
    _nikC = TextEditingController(text: s.nikKetua);
    _anggotaC = TextEditingController(text: s.jumlahAnggota);
  }

  @override
  void dispose() {
    _namaC.dispose();
    _hpC.dispose();
    _nikC.dispose();
    _anggotaC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = ref.read(sktFormProvider.notifier);
    final namaKelompok = ref.watch(
        sktFormProvider.select((s) => s.namaKelompok));

    return _StepContainer(
      title: '2. Data Ketua',
      children: [
        _KelompokNamePill(name: namaKelompok),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Nama Ketua Kelompok',
          hint: 'cth: Jenoardi',
          controller: _namaC,
          onChanged: n.setNamaKetua,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Nomor HP / WhatsApp',
          hint: 'cth: 085245336985',
          controller: _hpC,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15),
          ],
          onChanged: n.setNomorHp,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'NIK',
          hint: 'cth: 3517110362xxxxxx (16 digit)',
          controller: _nikC,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          onChanged: n.setNikKetua,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Jumlah Anggota',
          hint: 'cth: 8',
          controller: _anggotaC,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: n.setJumlahAnggota,
        ),
      ],
    );
  }
}

// ====================== STEP 3 — Data Ternak ======================

class Step3DataTernak extends ConsumerStatefulWidget {
  const Step3DataTernak({super.key});

  @override
  ConsumerState<Step3DataTernak> createState() => _Step3DataTernakState();
}

class _Step3DataTernakState extends ConsumerState<Step3DataTernak> {
  late TextEditingController _jumlahC;
  late TextEditingController _lokasiC;

  @override
  void initState() {
    super.initState();
    final s = ref.read(sktFormProvider);
    _jumlahC = TextEditingController(text: s.jumlahTernak);
    _lokasiC = TextEditingController(text: s.lokasiKandang);
  }

  @override
  void dispose() {
    _jumlahC.dispose();
    _lokasiC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = ref.read(sktFormProvider.notifier);
    final s = ref.watch(sktFormProvider);

    return _StepContainer(
      title: '3. Data Ternak',
      children: [
        _KelompokNamePill(name: s.namaKelompok),
        const SizedBox(height: AppSpacing.md),
        AppDropdownField<JenisTernak>(
          label: 'Jenis Ternak',
          hint: 'Jenis Ternak',
          value: s.jenisTernak,
          items: JenisTernak.values
              .map((j) => DropdownMenuItem(
                    value: j,
                    child: Text(j.label),
                  ))
              .toList(),
          onChanged: n.setJenisTernak,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Jumlah Ternak',
          hint: 'cth: 30',
          controller: _jumlahC,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: n.setJumlahTernak,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Lokasi Kandang',
          hint: 'cth: Dusun Suko',
          controller: _lokasiC,
          onChanged: n.setLokasiKandang,
        ),
        const SizedBox(height: AppSpacing.md),
        AppDropdownField<KondisiTernak>(
          label: 'Kondisi Umum',
          hint: 'Kondisi Ternak',
          value: s.kondisiUmum,
          items: KondisiTernak.values
              .map((k) => DropdownMenuItem(
                    value: k,
                    child: Text(k.label),
                  ))
              .toList(),
          onChanged: n.setKondisiUmum,
        ),
      ],
    );
  }
}

// ====================== STEP 4 — Dokumentasi ======================

class Step4Dokumentasi extends ConsumerWidget {
  const Step4Dokumentasi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namaKelompok =
        ref.watch(sktFormProvider.select((s) => s.namaKelompok));
    final revisionMode =
        ref.watch(sktFormProvider.select((s) => s.revisionMode));
    final revisionNotes =
        ref.watch(sktFormProvider.select((s) => s.revisionNotes));

    return _StepContainer(
      title: '4. Dokumen Pendukung',
      children: [
        if (revisionMode) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: AppColors.error),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Mode Revisi: upload ulang dokumen yang ditandai merah di bawah.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        _KelompokNamePill(name: namaKelompok),
        const SizedBox(height: AppSpacing.md),
        ...SktDokumenType.values.map((type) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _DokumenUploadItem(
                type: type,
                revisionNote: revisionNotes[type.code],
              ),
            )),
      ],
    );
  }
}

class _DokumenUploadItem extends ConsumerWidget {
  final SktDokumenType type;

  /// Catatan dari petugas kalau dokumen ini perlu revisi.
  /// Null kalau gak ada catatan.
  final String? revisionNote;

  const _DokumenUploadItem({
    required this.type,
    this.revisionNote,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dokumenFile = ref.watch(
      sktFormProvider.select((s) => s.dokumenFiles[type.code]),
    );
    final hasFile = dokumenFile != null;
    final needsRevision = revisionNote != null;

    return Container(
      padding: needsRevision
          ? const EdgeInsets.all(AppSpacing.sm)
          : EdgeInsets.zero,
      decoration: needsRevision
          ? BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.4),
                width: 1.5,
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  type.label,
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textDarker,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (needsRevision)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'Perlu Revisi',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            type.deskripsi,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          if (needsRevision) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.chat_bubble_outline,
                      size: 14, color: AppColors.error),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      revisionNote!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textDark,
                        fontSize: 11,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _UploadButton(
                  hasFile: hasFile,
                  fileName: hasFile ? dokumenFile.name : 'Unggah File',
                  onTap: () => _pickFile(context, ref),
                  onRemove: hasFile
                      ? () {
                          // Delete file dari disk (fire-and-forget)
                          FileStorageService.deleteFile(dokumenFile.path);
                          ref
                              .read(sktFormProvider.notifier)
                              .removeDokumen(type);
                        }
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _LihatFileButton(
                  enabled: hasFile,
                  onTap: () {
                    _showPreview(context, dokumenFile!);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            hasFile
                ? 'PDF • ${dokumenFile.formattedSize}'
                : 'PDF • Maks. 5 MB',
            style: AppTypography.bodySmall.copyWith(
              color: hasFile ? AppColors.success : AppColors.textMuted,
              fontSize: 11,
              fontWeight: hasFile ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// REAL file picker — pakai package file_picker.
  /// Filter: PDF only, max 5 MB.
  /// File akan di-copy ke app's document directory biar persistent.
  Future<void> _pickFile(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final picked = result.files.first;

      // Validate size (5 MB = 5 * 1024 * 1024 bytes)
      const maxSize = 5 * 1024 * 1024;
      if (picked.size > maxSize) {
        if (!context.mounted) return;
        _showError(context,
            'Ukuran file terlalu besar (${_formatBytes(picked.size)}). Maksimal 5 MB.');
        return;
      }

      if (picked.path == null) {
        if (!context.mounted) return;
        _showError(context, 'Gagal membaca file. Coba file lain.');
        return;
      }

      // Show loading dialog saat copy (biar user gak ngira freeze)
      if (!context.mounted) return;
      _showLoadingDialog(context, 'Menyimpan file...');

      String persistentPath;
      try {
        // Copy ke app docs biar persistent
        persistentPath = await FileStorageService.copyToAppDocs(
          sourcePath: picked.path!,
          fileName: picked.name,
        );
      } catch (e) {
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop(); // close loading
        _showError(context, 'Gagal menyimpan file: $e');
        return;
      }

      // Close loading dialog
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      // Kalau dokumen ini udah punya file lama (mis. replace), cleanup
      final oldFile = ref.read(
        sktFormProvider.select((s) => s.dokumenFiles[type.code]),
      );
      if (oldFile != null) {
        // Async cleanup — fire-and-forget
        FileStorageService.deleteFile(oldFile.path);
      }

      // Save ke state dengan path baru (app docs)
      ref.read(sktFormProvider.notifier).setDokumen(
            type,
            DokumenFile(
              path: persistentPath,
              name: picked.name,
              sizeBytes: picked.size,
            ),
          );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File "${picked.name}" berhasil di-upload'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Gagal pilih file: $e');
    }
  }

  void _showLoadingDialog(BuildContext context, String message) {
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
                message,
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showPreview(BuildContext context, DokumenFile file) {
    // Cek dulu apakah file bisa dibuka (karena dummy path / path invalid)
    final fileExists = File(file.path).existsSync();
    if (!fileExists) {
      _showError(
        context,
        'File tidak ditemukan. Coba upload ulang dokumen.',
      );
      return;
    }

    // Navigate ke PDF viewer full-screen
    context.push('/pdf-viewer', extra: {
      'filePath': file.path,
      'fileName': file.name,
    });
  }
}

class _UploadButton extends StatelessWidget {
  final bool hasFile;
  final String fileName;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _UploadButton({
    required this.hasFile,
    required this.fileName,
    required this.onTap,
    this.onRemove,
  });

  /// Potong nama file kalau > 20 karakter: kasih "...[6 char terakhir]"
  /// Contoh: "KTP_Jenoardi_2026_final_v3.pdf" → "KTP_Jeno...v3.pdf"
  String _truncate(String name) {
    if (name.length <= 20) return name;
    final ext = name.contains('.') ? name.substring(name.lastIndexOf('.')) : '';
    final prefix = name.substring(0, 10);
    return '$prefix...$ext';
  }

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
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(
              color: hasFile ? AppColors.primary : AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasFile
                    ? Icons.description_outlined
                    : Icons.upload_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  hasFile ? _truncate(fileName) : 'Unggah File',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasFile && onRemove != null) ...[
                const SizedBox(width: AppSpacing.xs),
                InkWell(
                  onTap: onRemove,
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LihatFileButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _LihatFileButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadius.button),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 18,
                  color: enabled
                      ? AppColors.primary
                      : AppColors.textMuted,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Lihat File',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====================== STEP 5 — Konfirmasi ======================

class Step5Konfirmasi extends ConsumerWidget {
  const Step5Konfirmasi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sktFormProvider);

    return _StepContainer(
      title: '5. Konfirmasi Pengajuan',
      children: [
        _KonfirmasiSection(
          nomor: '1',
          title: 'Data Kelompok',
          content: [
            s.namaKelompok,
            '${s.alamatKelompok}, ${s.desaKecamatan}, ${s.kabupaten}, ${s.provinsi}',
          ],
        ),
        _KonfirmasiSection(
          nomor: '2',
          title: 'Data Ketua',
          content: [
            s.namaKetua,
            'NIK: ${s.nikKetua}',
            s.nomorHp,
          ],
        ),
        _KonfirmasiSection(
          nomor: '3',
          title: 'Data Ternak',
          content: [
            s.jenisTernak?.label ?? '-',
            '${s.jumlahTernak} ekor',
            s.lokasiKandang,
            s.kondisiUmum?.label ?? '-',
          ],
        ),
        _KonfirmasiDokumenSection(files: s.dokumenFiles),
      ],
    );
  }
}

class _KonfirmasiSection extends StatelessWidget {
  final String nomor;
  final String title;
  final List<String> content;

  const _KonfirmasiSection({
    required this.nomor,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$nomor. $title',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),
          ...content.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  line,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _KonfirmasiDokumenSection extends StatelessWidget {
  final Map<String, DokumenFile> files;

  const _KonfirmasiDokumenSection({required this.files});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '4. Dokumen Pendukung',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.sm),
          ...SktDokumenType.values.map((type) {
            final uploaded = files.containsKey(type.code);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined,
                      size: 16, color: AppColors.textMuted),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      '${type.label} (PDF)',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  Icon(
                    uploaded ? Icons.check : Icons.close,
                    size: 18,
                    color: uploaded ? AppColors.success : AppColors.error,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ====================== SHARED WIDGETS ======================

class _StepContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _StepContainer({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _KelompokNamePill extends StatelessWidget {
  final String name;

  const _KelompokNamePill({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.agriculture_rounded,
              size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              name,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textDarker,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
