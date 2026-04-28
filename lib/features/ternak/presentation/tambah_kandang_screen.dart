import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../providers/kandang_provider.dart';

class TambahKandangScreen extends ConsumerStatefulWidget {
  const TambahKandangScreen({super.key});

  @override
  ConsumerState<TambahKandangScreen> createState() =>
      _TambahKandangScreenState();
}

class _TambahKandangScreenState extends ConsumerState<TambahKandangScreen> {
  final _namaController = TextEditingController();
  final _populasiController = TextEditingController();
  final _kondisiController = TextEditingController(text: 'Sehat');

  JenisTernak? _selectedJenis;
  File? _foto;

  @override
  void dispose() {
    _namaController.dispose();
    _populasiController.dispose();
    _kondisiController.dispose();
    super.dispose();
  }

  Future<void> _pickFoto() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() => _foto = File(picked.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal upload foto: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleSubmit() {
    if (_namaController.text.trim().isEmpty) {
      _showError('Nama kandang tidak boleh kosong');
      return;
    }
    if (_selectedJenis == null) {
      _showError('Pilih jenis ternak');
      return;
    }
    final populasi = int.tryParse(_populasiController.text.trim());
    if (populasi == null || populasi <= 0) {
      _showError('Jumlah populasi harus angka > 0');
      return;
    }

    final newKandang = Kandang(
      id: 'k_${DateTime.now().millisecondsSinceEpoch}',
      nama: _namaController.text.trim(),
      jenis: _selectedJenis!,
      jumlahPopulasi: populasi,
      jumlahAwal: populasi,
      kondisi: _kondisiController.text.trim().isEmpty
          ? 'Sehat'
          : _kondisiController.text.trim(),
      fotoPath: _foto?.path,
    );

    ref.read(kandangListProvider.notifier).tambah(newKandang);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _BerhasilTambahDialog(
        onLanjut: () {
          Navigator.of(ctx).pop();
          context.pop();
        },
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Tambah Kandang',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoBanner(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Data Kandang',
                    style: AppTypography.headingSmall.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(AppRadius.card),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFotoUploader(),
                        const SizedBox(height: AppSpacing.sm),
                        _FieldLabel('Nama Kandang'),
                        _buildTextField(
                          controller: _namaController,
                          hint: 'cth: Sapi Perah',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _FieldLabel('Jenis Ternak'),
                        _buildJenisDropdown(),
                        const SizedBox(height: AppSpacing.sm),
                        _FieldLabel('Jumlah Populasi'),
                        _buildTextField(
                          controller: _populasiController,
                          hint: 'cth: 9',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _FieldLabel('Kondisi'),
                        _buildTextField(
                          controller: _kondisiController,
                          hint: 'cth: Sehat',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSubmitButton(),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 18, color: AppColors.textDarker),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'Bagikan kode ini ke anggota, agar mereka bisa bergabung '
              'ke kelompok ternakmu di Ternovia!',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textDark,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotoUploader() {
    return InkWell(
      onTap: _pickFoto,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: _foto != null
              ? AppColors.transparent
              : AppColors.infoBg.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: _foto != null
              ? null
              : Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                  style: BorderStyle.solid,
                ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _foto != null
            ? Image.file(_foto!, fit: BoxFit.cover)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.creamMuted.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Unggah Foto Kandang',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: AppTypography.bodyMedium.copyWith(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textMuted,
          fontSize: 13,
        ),
        filled: true,
        fillColor: AppColors.infoBg,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildJenisDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<JenisTernak>(
          value: _selectedJenis,
          isExpanded: true,
          hint: Text(
            'Jenis Ternak',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textDarker,
            fontSize: 13,
          ),
          items: JenisTernak.values.map((j) {
            return DropdownMenuItem(
              value: j,
              child: Text(j.label),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedJenis = v),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        child: Text(
          'Submit',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.textDarker,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

/// Pop-up "🎉 Berhasil Menambah Ternak!"
class _BerhasilTambahDialog extends StatelessWidget {
  final VoidCallback onLanjut;

  const _BerhasilTambahDialog({required this.onLanjut});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Confetti + checkmark
            SizedBox(
              width: 120,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ...List.generate(12, (i) {
                    final angle = (i * 30) * math.pi / 180;
                    final radius = 45.0 + (i % 3) * 8;
                    final dx = math.cos(angle) * radius;
                    final dy = math.sin(angle) * radius;
                    final colors = [
                      AppColors.primary,
                      AppColors.accent,
                      Colors.amber,
                    ];
                    return Transform.translate(
                      offset: Offset(dx, dy),
                      child: Container(
                        width: i.isEven ? 5 : 4,
                        height: i.isEven ? 5 : 4,
                        decoration: BoxDecoration(
                          color: colors[i % 3],
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Berhasil Menambah Ternak!',
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Ternak baru kamu berhasil ditambahkan!',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onLanjut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.button),
                  ),
                ),
                child: Text(
                  'Lanjut',
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
      ),
    );
  }
}
