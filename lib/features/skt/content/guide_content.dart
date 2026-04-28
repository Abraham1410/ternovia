import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Section dalam guide — bisa berupa paragraf, bullet list, numbered list,
/// atau image (path ke asset). Kalau isHighlight, di-render dengan bg info.
class GuideSection {
  final String? title;
  final String? paragraph;
  final List<String>? bullets;
  final List<String>? numbered;

  /// "Flow arrow" — list status yang dirender horizontal dengan panah.
  /// Contoh: ['Diajukan', 'Direview', 'Diverifikasi', 'Disetujui/Ditolak']
  final List<String>? flowStatus;

  /// Asset image path (optional) — dirender setelah paragraph/bullets.
  final String? imageAsset;

  final IconData? icon;
  final bool isHighlight;

  /// Custom subtitle bold inline di section (mis. "Tips:").
  final String? boldIntro;

  const GuideSection({
    this.title,
    this.paragraph,
    this.bullets,
    this.numbered,
    this.flowStatus,
    this.imageAsset,
    this.icon,
    this.isHighlight = false,
    this.boldIntro,
  });
}

/// Static content untuk 3 screen: Panduan, S&K, Contoh Dokumen.
class SktGuideContent {
  SktGuideContent._();

  // ============== PANDUAN PENGAJUAN ==============
  // Sesuai design Figma (Panduan_Pengajuan_SKT.png)
  static const List<GuideSection> panduanPengajuan = [
    GuideSection(
      title: 'Apa itu SKT?',
      paragraph:
          'Surat Keterangan Ternak (SKT) adalah dokumen resmi yang digunakan '
          'sebagai bukti legalitas kelompok peternak. SKT biasanya dibutuhkan '
          'untuk pengajuan bantuan, pendataan pemerintah, hingga kerja sama '
          'dengan instansi.',
    ),
    GuideSection(
      title: 'Cara Mengajukan SKT di Ternovia:',
      numbered: [
        'Tentukan kelompok ternak yang akan diajukan SKT-nya.',
        'Masukkan jenis ternak, jumlah ternak, dan lokasi kandang.',
        'Tambahkan dokumen pendukung seperti foto kandang, KTP ketua, dan surat pengantar.',
        'Pastikan semua informasi sudah benar sebelum dikirim.',
        'Setelah dikirim, pengajuan akan diproses oleh petugas.',
        'Kamu bisa melihat status pengajuan SKT real time:',
      ],
    ),
    GuideSection(
      flowStatus: [
        'Diajukan',
        'Direview',
        'Diverifikasi',
        'Disetujui / Ditolak',
      ],
    ),
    GuideSection(
      boldIntro: 'Tips:',
      paragraph:
          'Gunakan data yang sesuai kondisi lapangan agar proses lebih '
          'cepat dan tidak perlu revisi.',
      isHighlight: true,
    ),
  ];

  // ============== SYARAT & KETENTUAN ==============
  // Sesuai design Figma (Frame_33880.png)
  static const List<GuideSection> syaratKetentuan = [
    GuideSection(
      title: 'Sebelum mengajukan SKT, pastikan hal berikut sudah terpenuhi:',
      numbered: [
        'Terdaftar sebagai anggota kelompok ternak',
        'Data kelompok sudah lengkap dan aktif',
        'Mengisi jumlah dan jenis ternak sesuai kondisi sebenarnya',
        'Lokasi kandang jelas dan dapat diverifikasi',
        'Dokumen pendukung dapat dibaca dengan jelas',
        'Tidak menggunakan data palsu',
        'Bersedia dilakukan pengecekan lapangan bila diperlukan',
      ],
    ),
    GuideSection(
      boldIntro: 'Catatan Penting:',
      paragraph:
          'Pengajuan yang tidak lengkap atau tidak sesuai fakta dapat '
          'ditolak atau diminta perbaikan',
      isHighlight: true,
    ),
  ];

  // ============== CONTOH DOKUMEN ==============
  // Sesuai design Figma (Frame_33882.png) — 10 item dengan images
  // Untuk sekarang, placeholder dulu — image asset akan di-wire setelah
  // user upload assets.
  static const List<GuideSection> contohDokumen = [
    GuideSection(
      paragraph:
          'Berikut contoh dokumen yang biasanya dibutuhkan saat pengajuan SKT:',
    ),
    GuideSection(
      title: '1. Foto Kandang',
      paragraph: 'Tampak depan dan bagian dalam kandang.',
      imageAsset: AppConstants.docFotoKandang,
    ),
    GuideSection(
      title: '2. KTP Ketua & Anggota Kelompok',
      paragraph: 'KTP ketua dan seluruh anggota kelompok',
      imageAsset: AppConstants.docKtpSample,
    ),
    GuideSection(
      title: '3. KK Ketua & Anggota Kelompok',
      paragraph: 'KK ketua dan seluruh anggota kelompok',
      imageAsset: AppConstants.docKkSample,
    ),
    GuideSection(
      title: '4. Lengkapi Form Data Terkait Ternak',
      paragraph:
          'Masukkan data secara lengkap dan sesuai dengan keadaan lapangan',
      imageAsset: AppConstants.docFormTernak,
    ),
    GuideSection(
      title: '5. Surat Kepala Desa',
      paragraph: 'Surat Pengantar Desa',
      imageAsset: AppConstants.docSuratKades,
    ),
    GuideSection(
      title: '6. Surat Permohonan SKT',
      paragraph:
          'Surat resmi dari kelompok ternak yang berisi permohonan '
          'penerbitan SKT. Surat harus ditandatangani oleh Ketua Kelompok '
          'dan dibubuhi stempel kelompok',
      imageAsset: AppConstants.docSuratPermohonan,
    ),
    GuideSection(
      title: '7. Susunan Pengurus & Jumlah Anggota',
      paragraph:
          'Dokumen yang berisi struktur kepengurusan dan daftar '
          'anggota aktif dalam kelompok ternak',
      imageAsset: AppConstants.docSusunanPengurus,
    ),
    GuideSection(
      title: '8. Berita Acara Pembentukan Kelompok',
      paragraph:
          'Berita acara yang menjelaskan proses pembentukan '
          'kelompok ternak dan disahkan oleh PPL setempat',
      imageAsset: AppConstants.docBeritaAcara,
    ),
    GuideSection(
      title: '9. Daftar Hadir Pembentukan Kelompok',
      paragraph: 'Daftar kehadiran anggota saat pembentukan kelompok ternak',
      imageAsset: AppConstants.docDaftarHadir,
    ),
    GuideSection(
      title: '10. Surat Keterangan Domisili dari Kepala Desa',
      paragraph:
          'Surat keterangan bertempat tinggal yang diterbitkan oleh kepala desa',
      imageAsset: AppConstants.docSuratDomisili,
    ),
    GuideSection(
      title: '11. Komoditas Ternak dan Jumlah Ternak yang diketahui P4H',
      paragraph:
          'Dokumen komoditas jumlah ternak dan jenis ternak yang diketahui P4H',
      imageAsset: AppConstants.docKomoditasTernak,
    ),
  ];
}
