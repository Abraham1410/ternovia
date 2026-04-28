import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';
import '../providers/kesehatan_provider.dart';

/// Input Kesehatan form — dipakai buat Mode Kandang, Per Individu, Mode Massal.
/// Perbedaan UI: header section (target) berbeda per mode.
class InputKesehatanScreen extends ConsumerStatefulWidget {
  final ModeInput mode;

  const InputKesehatanScreen({super.key, required this.mode});

  @override
  ConsumerState<InputKesehatanScreen> createState() =>
      _InputKesehatanScreenState();
}

class _InputKesehatanScreenState
    extends ConsumerState<InputKesehatanScreen> {
  DateTime _tanggal = DateTime(2026, 2, 12);
  KondisiUmum? _kondisiUmum;
  NafsuMakan? _nafsuMakan;
  Minum? _minum;
  final _suhuController = TextEditingController();
  final _kelembapanController = TextEditingController();
  final Set<Lingkungan> _lingkungan = {};
  final Set<Gejala> _gejala = {};
  final Set<Penanganan> _penanganan = {};
  String? _selectedTernak;

  @override
  void dispose() {
    _suhuController.dispose();
    _kelembapanController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _tanggal = picked);
    }
  }

  Future<void> _pickTernak() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (_) => const _PilihTernakSheet(),
    );
    if (result != null) {
      setState(() => _selectedTernak = result);
    }
  }

  void _handleSubmit() {
    if (widget.mode == ModeInput.individu && _selectedTernak == null) {
      _showError('Pilih ternak terlebih dahulu');
      return;
    }

    final record = RecordKesehatan(
      id: 'r_${DateTime.now().millisecondsSinceEpoch}',
      targetId: _selectedTernak ?? 'Batch Kandang A',
      mode: widget.mode,
      tanggal: _tanggal,
      kondisi: _kondisiUmum,
      nafsu: _nafsuMakan,
      minum: _minum,
      suhu: double.tryParse(_suhuController.text),
      kelembapan: double.tryParse(_kelembapanController.text),
      lingkungan: _lingkungan,
      gejala: _gejala,
      penanganan: _penanganan,
    );

    ref.read(recordKesehatanProvider.notifier).tambah(record);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _BerhasilUpdateDialog(
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
            title: 'Input Kesehatan',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTargetHeader(),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCard(
                    title: 'Pilih Tanggal',
                    child: InkWell(
                      onTap: _pickTanggal,
                      borderRadius:
                          BorderRadius.circular(AppRadius.button),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _formatDate(_tanggal),
                              style:
                                  AppTypography.bodyMedium.copyWith(
                                color: AppColors.textDarker,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.calendar_today_outlined,
                                color: AppColors.textMuted, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCard(
                    title: 'Kondisi Umum',
                    child: Row(
                      children: [
                        Expanded(
                          child: _CheckPill(
                            label: 'Aktifitas',
                            checked:
                                _kondisiUmum == KondisiUmum.aktifitas,
                            onTap: () => setState(() =>
                                _kondisiUmum = KondisiUmum.aktifitas),
                          ),
                        ),
                        Expanded(
                          child: _CheckPill(
                            label: 'Lesu',
                            checked: _kondisiUmum == KondisiUmum.lesu,
                            onTap: () => setState(() =>
                                _kondisiUmum = KondisiUmum.lesu),
                          ),
                        ),
                        Expanded(
                          child: _CheckPill(
                            label: 'Gelisah',
                            checked:
                                _kondisiUmum == KondisiUmum.gelisah,
                            onTap: () => setState(() =>
                                _kondisiUmum = KondisiUmum.gelisah),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCard(
                    title: 'Nafsu Makan',
                    child: Row(
                      children: [
                        Expanded(
                          child: _CheckPill(
                            label: 'Normal',
                            checked: _nafsuMakan == NafsuMakan.normal,
                            onTap: () => setState(() =>
                                _nafsuMakan = NafsuMakan.normal),
                          ),
                        ),
                        Expanded(
                          child: _CheckPill(
                            label: 'Berkurang',
                            checked:
                                _nafsuMakan == NafsuMakan.berkurang,
                            onTap: () => setState(() =>
                                _nafsuMakan = NafsuMakan.berkurang),
                          ),
                        ),
                        Expanded(
                          child: _CheckPill(
                            label: 'Tidak Nafsu',
                            checked:
                                _nafsuMakan == NafsuMakan.tidakNafsu,
                            onTap: () => setState(() =>
                                _nafsuMakan = NafsuMakan.tidakNafsu),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCard(
                    title: 'Minum',
                    child: Row(
                      children: [
                        Expanded(
                          child: _CheckPill(
                            label: 'Normal',
                            checked: _minum == Minum.normal,
                            onTap: () => setState(
                                () => _minum = Minum.normal),
                          ),
                        ),
                        Expanded(
                          child: _CheckPill(
                            label: 'Berkurang',
                            checked: _minum == Minum.berkurang,
                            onTap: () => setState(
                                () => _minum = Minum.berkurang),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSuhuCard(),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCard(
                    title: 'Gejala',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _CheckPill(
                                label: 'Batuk',
                                checked: _gejala.contains(Gejala.batuk),
                                onTap: () => _toggleGejala(Gejala.batuk),
                              ),
                            ),
                            Expanded(
                              child: _CheckPill(
                                label: 'Diare',
                                checked: _gejala.contains(Gejala.diare),
                                onTap: () => _toggleGejala(Gejala.diare),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _CheckPill(
                                label: 'Pincang',
                                checked:
                                    _gejala.contains(Gejala.pincang),
                                onTap: () =>
                                    _toggleGejala(Gejala.pincang),
                              ),
                            ),
                            Expanded(
                              child: _CheckPill(
                                label: 'Mata Berair',
                                checked: _gejala
                                    .contains(Gejala.mataBerair),
                                onTap: () =>
                                    _toggleGejala(Gejala.mataBerair),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCard(
                    title: 'Penanganan',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _CheckPill(
                                label: 'Sudah vaksin hari ini',
                                checked: _penanganan.contains(
                                    Penanganan.sudahVaksinHariIni),
                                onTap: () => _togglePenanganan(
                                    Penanganan.sudahVaksinHariIni),
                              ),
                            ),
                            Expanded(
                              child: _CheckPill(
                                label: 'Berikan Obat',
                                checked: _penanganan
                                    .contains(Penanganan.berikanObat),
                                onTap: () => _togglePenanganan(
                                    Penanganan.berikanObat),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _CheckPill(
                                label: 'Tambahkan Vitamin',
                                checked: _penanganan.contains(
                                    Penanganan.tambahkanVitamin),
                                onTap: () => _togglePenanganan(
                                    Penanganan.tambahkanVitamin),
                              ),
                            ),
                            Expanded(
                              child: _CheckPill(
                                label: 'Diisolasi',
                                checked: _penanganan
                                    .contains(Penanganan.diisolasi),
                                onTap: () => _togglePenanganan(
                                    Penanganan.diisolasi),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
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
                        'Submit',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetHeader() {
    if (widget.mode == ModeInput.individu) {
      // Selectable ternak
      return InkWell(
        onTap: _pickTernak,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm + 2),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _selectedTernak ?? 'Pilih ternak',
                  style: AppTypography.headingSmall.copyWith(
                    color: _selectedTernak != null
                        ? AppColors.textDarker
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      );
    }
    // Mode Kandang / Massal → static label
    final title = widget.mode == ModeInput.kandang
        ? 'Batch Kandang A'
        : 'Semua Ternak (Mode Massal)';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Text(
        title,
        style: AppTypography.headingSmall.copyWith(
          color: AppColors.textDarker,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const Divider(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSuhuCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suhu / Lingkungan',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const Divider(height: 12),
          Row(
            children: [
              const Icon(Icons.thermostat_outlined,
                  size: 16, color: AppColors.textDarker),
              const SizedBox(width: 4),
              Text('Suhu',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDarker,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: _buildInlineInput(_suhuController, 'cth:24')),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.water_drop_outlined,
                  size: 16, color: AppColors.textDarker),
              const SizedBox(width: 4),
              Text('Kelembapan',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textDarker,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                  child: _buildInlineInput(_kelembapanController, 'cth:24')),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _CheckPill(
                  label: 'Normal',
                  checked: _lingkungan.contains(Lingkungan.normal),
                  onTap: () {
                    setState(() {
                      if (_lingkungan.contains(Lingkungan.normal)) {
                        _lingkungan.remove(Lingkungan.normal);
                      } else {
                        _lingkungan.add(Lingkungan.normal);
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: _CheckPill(
                  label: 'Bau Kandang',
                  checked: _lingkungan.contains(Lingkungan.bauKandang),
                  onTap: () {
                    setState(() {
                      if (_lingkungan.contains(Lingkungan.bauKandang)) {
                        _lingkungan.remove(Lingkungan.bauKandang);
                      } else {
                        _lingkungan.add(Lingkungan.bauKandang);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInlineInput(TextEditingController controller, String hint) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textDarker,
            fontSize: 12,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
            border: InputBorder.none,
            isCollapsed: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  void _toggleGejala(Gejala g) {
    setState(() {
      if (_gejala.contains(g)) {
        _gejala.remove(g);
      } else {
        _gejala.add(g);
      }
    });
  }

  void _togglePenanganan(Penanganan p) {
    setState(() {
      if (_penanganan.contains(p)) {
        _penanganan.remove(p);
      } else {
        _penanganan.add(p);
      }
    });
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }
}

// ============== CheckPill (checkbox) ==============

class _CheckPill extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const _CheckPill({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: checked ? AppColors.primary : AppColors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: checked ? AppColors.primary : AppColors.textMuted,
                  width: 1.5,
                ),
              ),
              child: checked
                  ? const Icon(Icons.check_rounded,
                      color: AppColors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textDark,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============== Pilih Ternak Bottom Sheet ==============

class _PilihTernakSheet extends StatelessWidget {
  const _PilihTernakSheet();

  @override
  Widget build(BuildContext context) {
    final ternakList = List.generate(
      10,
      (i) => 'Sapi Perah #${101 + i}',
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 32),
                Expanded(
                  child: Center(
                    child: Text(
                      'Pilih Ternak',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textDarker,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            ...ternakList.map(
              (nama) => InkWell(
                onTap: () => Navigator.of(context).pop(nama),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.divider,
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    nama,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textDarker,
                      fontSize: 13,
                    ),
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

// ============== Pop-up Berhasil Update Kesehatan ==============

class _BerhasilUpdateDialog extends StatelessWidget {
  final VoidCallback onLanjut;

  const _BerhasilUpdateDialog({required this.onLanjut});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    'Berhasil Update Kesehatan Ternak!',
                    textAlign: TextAlign.center,
                    style: AppTypography.headingMedium.copyWith(
                      color: AppColors.textDarker,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Update kesehatan ternak terbaru kamu\nberhasil ditambahkan!',
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
