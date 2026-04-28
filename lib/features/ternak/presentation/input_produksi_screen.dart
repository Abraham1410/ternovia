import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_size.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../providers/produksi_provider.dart';

class InputProduksiScreen extends ConsumerStatefulWidget {
  const InputProduksiScreen({super.key});

  @override
  ConsumerState<InputProduksiScreen> createState() =>
      _InputProduksiScreenState();
}

class _InputProduksiScreenState extends ConsumerState<InputProduksiScreen> {
  DateTime _tanggal = DateTime(2026, 2, 12);
  final _totalController = TextEditingController();
  final _layakController = TextEditingController();
  final _tidakLayakController = TextEditingController();
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _totalController.dispose();
    _layakController.dispose();
    _tidakLayakController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  void _handleSubmit() {
    final total = double.tryParse(_totalController.text.replaceAll(',', '.'));
    if (total == null || total <= 0) {
      _showError('Jumlah produksi harus berupa angka > 0');
      return;
    }
    final layak = double.tryParse(_layakController.text.replaceAll(',', '.')) ?? 0;
    final tidakLayak = double.tryParse(_tidakLayakController.text.replaceAll(',', '.')) ?? 0;

    final record = RecordProduksi(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      batchId: 'k_001',
      tanggal: _tanggal,
      jumlahTotal: total,
      kualitasLayak: layak,
      kualitasTidakLayak: tidakLayak,
      catatan: _catatanController.text.trim().isEmpty
          ? null
          : _catatanController.text.trim(),
    );

    ref.read(produksiListProvider.notifier).tambah(record);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _BerhasilInputProduksiDialog(
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
            title: 'Input Produksi',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Batch header
                  Container(
                    padding: EdgeInsets.all(AppSize.sm + 2),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSize.rCard),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Batch Kandang A',
                            style: AppTypography.headingSmall.copyWith(
                              color: AppColors.textDarker,
                              fontWeight: FontWeight.w700,
                              fontSize: AppSize.fs14,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            color: AppColors.textMuted, size: AppSize.iconMd),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.sm),
                  // Tanggal
                  Container(
                    padding: EdgeInsets.all(AppSize.sm + 2),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSize.rCard),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Tanggal',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textDarker,
                            fontWeight: FontWeight.w700,
                            fontSize: AppSize.fs13,
                          ),
                        ),
                        const Divider(height: 12),
                        InkWell(
                          onTap: _pickTanggal,
                          borderRadius:
                              BorderRadius.circular(AppSize.rButton),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.sm,
                              vertical: 8.h,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _formatDate(_tanggal),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textDarker,
                                    fontSize: AppSize.fs13,
                                  ),
                                ),
                                const Spacer(),
                                Icon(Icons.calendar_today_outlined,
                                    color: AppColors.textMuted,
                                    size: AppSize.iconMd),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.sm),
                  // Input fields
                  Container(
                    padding: EdgeInsets.all(AppSize.sm + 2),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSize.rCard),
                    ),
                    child: Column(
                      children: [
                        _ProduksiInputRow(
                          label: 'Jumlah Produksi',
                          controller: _totalController,
                        ),
                        SizedBox(height: AppSize.xs),
                        _ProduksiInputRow(
                          label: 'Kualitas Susu Layak',
                          controller: _layakController,
                        ),
                        SizedBox(height: AppSize.xs),
                        _ProduksiInputRow(
                          label: 'Kualitas Susu Tidak Layak',
                          controller: _tidakLayakController,
                        ),
                        SizedBox(height: AppSize.xs),
                        _CatatanRow(controller: _catatanController),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSize.rButton),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: AppSize.fs15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }
}

class _ProduksiInputRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _ProduksiInputRow({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: AppSize.fs12,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(width: AppSize.xs),
        Expanded(
          flex: 2,
          child: Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: AppSize.xs),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(AppSize.rXl),
            ),
            child: Center(
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textDarker,
                  fontSize: AppSize.fs12,
                ),
                decoration: InputDecoration(
                  hintText: 'cth:24',
                  hintStyle: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: AppSize.fs12,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.xs),
        Container(
          height: 32.h,
          padding: EdgeInsets.symmetric(
              horizontal: AppSize.sm, vertical: 6.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(AppSize.rXl),
          ),
          child: Center(
            child: Text(
              'Liter',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textDark,
                fontSize: AppSize.fs11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CatatanRow extends StatelessWidget {
  final TextEditingController controller;

  const _CatatanRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'Catatan',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textDarker,
                fontWeight: FontWeight.w700,
                fontSize: AppSize.fs12,
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.xs),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.xs,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(AppSize.rXl),
            ),
            child: TextField(
              controller: controller,
              maxLines: 2,
              minLines: 1,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textDarker,
                fontSize: AppSize.fs12,
              ),
              decoration: InputDecoration(
                hintText: 'cth:24',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: AppSize.fs12,
                ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Pop-up "Berhasil Input Produksi"
class _BerhasilInputProduksiDialog extends StatelessWidget {
  final VoidCallback onLanjut;

  const _BerhasilInputProduksiDialog({required this.onLanjut});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSize.xl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.rLg),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120.w,
              height: 100.h,
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
                      offset: Offset(dx.w, dy.h),
                      child: Container(
                        width: (i.isEven ? 5 : 4).w,
                        height: (i.isEven ? 5 : 4).w,
                        decoration: BoxDecoration(
                          color: colors[i % 3],
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: AppSize.iconXl + 4.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSize.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🎉', style: TextStyle(fontSize: AppSize.fs18)),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    'Berhasil Input Produksi!',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w800,
                      fontSize: AppSize.fs16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.xs),
            Text(
              'Data produksi harian kamu berhasil dicatat!',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
                fontSize: AppSize.fs13,
                height: 1.4,
              ),
            ),
            SizedBox(height: AppSize.lg),
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: onLanjut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.rButton),
                  ),
                ),
                child: Text(
                  'Lanjut',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.fs15,
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
