import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';

/// Laporan Kunjungan screen — full detail report dari kunjungan petugas.
/// Match Figma: Kelompok info, Detail Laporan, Populasi, Kondisi Ternak,
/// Kondisi Kandang, Dokumentasi, Catatan Lapangan, Rekomendasi.
class LaporanKunjunganScreen extends StatelessWidget {
  const LaporanKunjunganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: 'Laporan Kunjungan',
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildKelompokCard(),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSection(
                    title: 'Detail Laporan Monitoring',
                    rows: const [
                      ['Jenis Ternak:', 'Sapi Perah'],
                      ['Alamat Lengkap:', 'Dsn. Suko, Ds. Sukolilo, Jombang, Jawa Timur'],
                      ['Tanggal:', 'Senin, 12 Februari 2026'],
                      ['Petugas:', 'Drh. Dwi'],
                      ['Status:', 'Selesai'],
                      ['Durasi:', '09.00 - 10.15 WIB (1 jam 15 menit)'],
                      ['Jenis Kunjungan:', 'Monitoring Rutin'],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSection(
                    title: 'Perkembangan Populasi Ternak',
                    rows: const [
                      ['Populasi awal:', '26 Ekor'],
                      ['Kelahiran:', '1 Ekor Jantan, 1 Ekor Betina'],
                      ['Kematian:', '-'],
                      ['Ternak Bunting:', '2 Ekor'],
                      ['Populasi Saat Ini:', '28 Ekor'],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSection(
                    title: 'Kondisi Ternak',
                    rows: const [
                      ['Status Kondisi:', 'Sehat'],
                      [
                        'Catatan:',
                        'Ditemukan 2 ekor dengan gejala nafsu makan menurun dan '
                            'diare ringan. Sudah diberikan vitamin dan probiotik oleh petugas.'
                      ],
                      ['Tindak Lanjut:', 'Pemantauan selama 3-5 hari ke depan'],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSection(
                    title: 'Kondisi Kandang',
                    rows: const [
                      ['Status Kandang:', 'Baik'],
                      [
                        'Catatan:',
                        'Perlu penambahan desinfeksi rutin setiap minggu untuk '
                            'mencegah penyebaran penyakit.'
                      ],
                      ['Tindak Lanjut:', 'Peningkatan desinfeksi rutin'],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildDokumentasi(),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSimpleCard(
                    title: 'Catatan Lapangan',
                    body: 'Pertemuan kelompok berjalan rutin setiap bulan. '
                        'Terdapat peningkatan populasi dibandingkan kunjungan sebelumnya. '
                        'Namun, perlu pengawasan terhadap 2 ekor sapi yang mengalami '
                        'gangguan pencernaan ringan.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildRekomendasi(),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKelompokCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kelompok Budi Pekerti',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.pets_rounded,
                  size: 14, color: AppColors.textDarker),
              const SizedBox(width: 4),
              Text(
                'Sapi Perah, 26 Ekor',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textDarker),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Dusun Suko, Desa Sukolilo, Jombang, Jawa Timur',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textDark,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF7C9A6F),
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              child: Text(
                'Selesai',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<List<String>> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const Divider(height: 12),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        r[0],
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textDarker,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        r[1],
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textDark,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDokumentasi() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dokumentasi Kegiatan',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(3, (i) {
              final colors = [
                const Color(0xFF7C9A6F),
                const Color(0xFFC6A985),
                const Color(0xFF6B8E80),
              ];
              final icons = [
                Icons.pets_rounded,
                Icons.water_drop_outlined,
                Icons.grass_rounded,
              ];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[i].withValues(alpha: 0.4),
                        borderRadius:
                            BorderRadius.circular(AppRadius.sm),
                      ),
                      alignment: Alignment.center,
                      child: Icon(icons[i],
                          color: AppColors.white, size: 36),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCard({required String title, required String body}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textDark,
              fontSize: 12,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildRekomendasi() {
    const items = [
      'Lakukan disinfeksi kandang secara berkala.',
      'Pantau ternak yang menunjukkan gejala gangguan kesehatan.',
      'Pertahankan pencatatan administrasi kelompok.',
      'Segera laporkan jika terjadi kematian tambahan.',
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekomendasi / Saran',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDarker,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          ...items.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textDark,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        t,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textDark,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
