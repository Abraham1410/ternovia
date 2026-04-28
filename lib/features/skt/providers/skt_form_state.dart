import '../../../core/constants/app_constants.dart';

/// Enum untuk dokumen pendukung SKT
enum SktDokumenType {
  suratPermohonan(
    'surat_permohonan',
    'Surat Permohonan SKT',
    'Upload surat permohonan SKT yang ditandatangani\nketua dan distempel kelompok.',
  ),
  susunanPengurus(
    'susunan_pengurus',
    'Susunan Pengurus & Jumlah Anggota',
    'Berisi daftar pengurus, jabatan, dan jumlah anggota\nkelompok.',
  ),
  ktpAnggota(
    'ktp_anggota',
    'KTP Anggota',
    'Gabungkan KTP ketua dan anggota dalam satu file\nPDF.',
  ),
  kkAnggota(
    'kk_anggota',
    'KK Anggota',
    'Digunakan untuk validasi data anggota kelompok.',
  ),
  beritaAcara(
    'berita_acara',
    'Berita Acara Pembentukan',
    'Dokumen pembentukan kelompok yang\nditandatangani PPL atau aparat desa.',
  ),
  daftarHadir(
    'daftar_hadir',
    'Daftar Hadir Pembentukan',
    'Daftar tanda tangan anggota saat pembentukan\nkelompok.',
  );

  final String code;
  final String label;
  final String deskripsi;
  const SktDokumenType(this.code, this.label, this.deskripsi);
}

/// Model file dokumen yang di-upload.
class DokumenFile {
  /// Full path ke file lokal
  final String path;

  /// Nama asli file (misal "KTP_Jenoardi.pdf")
  final String name;

  /// Size file dalam bytes
  final int sizeBytes;

  const DokumenFile({
    required this.path,
    required this.name,
    required this.sizeBytes,
  });

  /// Format size jadi human-readable (misal "1.2 MB", "450 KB")
  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    final mb = sizeBytes / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }
}

class SktFormState {
  // ===== Step 1: Data Kelompok =====
  final String namaKelompok;
  final String alamatKelompok;
  final String desaKecamatan;
  final String kabupaten;
  final String provinsi;

  // ===== Step 2: Data Ketua =====
  final String namaKetua;
  final String nomorHp;
  final String nikKetua;
  final String jumlahAnggota;

  // ===== Step 3: Data Ternak =====
  final JenisTernak? jenisTernak;
  final String jumlahTernak;
  final String lokasiKandang;
  final KondisiTernak? kondisiUmum;

  // ===== Step 4: Dokumentasi =====
  /// Map dokumen: key = SktDokumenType.code, value = DokumenFile
  final Map<String, DokumenFile> dokumenFiles;

  // ===== Meta =====
  /// Step saat ini (1..5, 5 = konfirmasi)
  final int currentStep;

  /// ID draft kalau ini lanjutan dari draft (null kalau baru)
  final String? draftId;

  /// Flag: form sedang dibuka dalam mode revisi.
  /// Kalau true, user cuma bisa edit dokumen (step 4) dan konfirmasi (step 5).
  final bool revisionMode;

  /// ID pengajuan yang lagi direvisi (kalau revisionMode = true).
  final String? pengajuanId;

  /// Catatan revisi per dokumen dari petugas (displayed di step 4).
  /// Key = SktDokumenType.code, Value = catatan petugas.
  final Map<String, String> revisionNotes;

  const SktFormState({
    this.namaKelompok = 'Kelompok Ternak Sukses Makmur',
    this.alamatKelompok = '',
    this.desaKecamatan = '',
    this.kabupaten = '',
    this.provinsi = '',
    this.namaKetua = '',
    this.nomorHp = '',
    this.nikKetua = '',
    this.jumlahAnggota = '',
    this.jenisTernak,
    this.jumlahTernak = '',
    this.lokasiKandang = '',
    this.kondisiUmum,
    this.dokumenFiles = const {},
    this.currentStep = 1,
    this.draftId,
    this.revisionMode = false,
    this.pengajuanId,
    this.revisionNotes = const {},
  });

  SktFormState copyWith({
    String? namaKelompok,
    String? alamatKelompok,
    String? desaKecamatan,
    String? kabupaten,
    String? provinsi,
    String? namaKetua,
    String? nomorHp,
    String? nikKetua,
    String? jumlahAnggota,
    JenisTernak? jenisTernak,
    String? jumlahTernak,
    String? lokasiKandang,
    KondisiTernak? kondisiUmum,
    Map<String, DokumenFile>? dokumenFiles,
    int? currentStep,
    String? draftId,
    bool? revisionMode,
    String? pengajuanId,
    Map<String, String>? revisionNotes,
  }) {
    return SktFormState(
      namaKelompok: namaKelompok ?? this.namaKelompok,
      alamatKelompok: alamatKelompok ?? this.alamatKelompok,
      desaKecamatan: desaKecamatan ?? this.desaKecamatan,
      kabupaten: kabupaten ?? this.kabupaten,
      provinsi: provinsi ?? this.provinsi,
      namaKetua: namaKetua ?? this.namaKetua,
      nomorHp: nomorHp ?? this.nomorHp,
      nikKetua: nikKetua ?? this.nikKetua,
      jumlahAnggota: jumlahAnggota ?? this.jumlahAnggota,
      jenisTernak: jenisTernak ?? this.jenisTernak,
      jumlahTernak: jumlahTernak ?? this.jumlahTernak,
      lokasiKandang: lokasiKandang ?? this.lokasiKandang,
      kondisiUmum: kondisiUmum ?? this.kondisiUmum,
      dokumenFiles: dokumenFiles ?? this.dokumenFiles,
      currentStep: currentStep ?? this.currentStep,
      draftId: draftId ?? this.draftId,
      revisionMode: revisionMode ?? this.revisionMode,
      pengajuanId: pengajuanId ?? this.pengajuanId,
      revisionNotes: revisionNotes ?? this.revisionNotes,
    );
  }
}

/// Model untuk 1 riwayat pengajuan SKT (buat list di main screen).
class SktPengajuan {
  final String id;
  final String namaKelompok;
  final int jumlahDokumen;
  final DateTime tanggalKirim;
  final SktStatus status;

  /// List catatan revisi dari petugas. Null/empty kalau status != perluRevisi.
  final List<RevisionNote>? revisionNotes;

  /// Tanggal petugas kirim catatan revisi.
  final DateTime? tanggalRevisi;

  const SktPengajuan({
    required this.id,
    required this.namaKelompok,
    required this.jumlahDokumen,
    required this.tanggalKirim,
    required this.status,
    this.revisionNotes,
    this.tanggalRevisi,
  });
}

/// Catatan revisi per dokumen dari petugas.
class RevisionNote {
  /// Code dari SktDokumenType yang bermasalah.
  final String dokumenCode;

  /// Label dokumen (buat display, biar gak perlu re-lookup).
  final String dokumenLabel;

  /// Catatan dari petugas (kenapa harus revisi).
  final String catatan;

  const RevisionNote({
    required this.dokumenCode,
    required this.dokumenLabel,
    required this.catatan,
  });
}

/// Model untuk draft SKT — simpan FULL SktFormState + metadata.
class SktDraft {
  final String id;
  final String namaKelompok;
  final DateTime tanggalSimpan;

  /// Full form state untuk di-resume.
  final SktFormState formState;

  const SktDraft({
    required this.id,
    required this.namaKelompok,
    required this.tanggalSimpan,
    required this.formState,
  });
}
