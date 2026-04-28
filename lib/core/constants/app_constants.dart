class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'TERNOVIA';
  static const String organizationName = 'Dinas Peternakan Kabupaten Jombang';

  // Asset paths - Images
  static const String logoTernovia = 'assets/images/logo_ternovia.png';
  static const String logoDinas = 'assets/images/logo_dinas.png';
  static const String onboardingHero = 'assets/images/onboarding_hero.png';
  static const String undanganIllustration = 'assets/images/undangan.png';
  static const String gabungKelompokIllustration =
      'assets/images/gabung_kelompok.png';
  static const String cardSehatTidak = 'assets/images/card_sehat&tidak.jpeg';

  // Asset paths - Icons
  static const String iconKelompokTernak = 'assets/icons/kelompok_ternak.png';
  static const String iconHasilProduksi = 'assets/icons/hasil_produksi.png';
  static const String iconLoveSehat = 'assets/icons/love_sehat.png';
  static const String iconSeruDicek = 'assets/icons/seru_dicek.png';
  static const String iconVaksinasiTernak = 'assets/icons/vaksinasi_ternak.png';
  static const String iconKonfirmasiBantuan = 'assets/icons/konfirmasi_bantuan.png';

  // Asset paths - Contoh Dokumen (buat Guide Screen)
  // Pake 5 file yang ditaro di assets/images/:
  // - kandang_contoh.png  (1 file)
  // - ktp_contoh.png      (1 file)
  // - KK_contoh.png       (dipake 2x: KK + Form Ternak)
  // - surat_contoh.png    (dipake 6x: Surat Kades, Permohonan, Susunan,
  //                        Berita Acara, Daftar Hadir, Domisili, Komoditas)
  static const String docFotoKandang = 'assets/images/kandang_contoh.png';
  static const String docKtpSample = 'assets/images/ktp_contoh.png';
  static const String docKkSample = 'assets/images/KK_contoh.png';
  static const String docFormTernak = 'assets/images/KK_contoh.png';
  static const String docSuratKades = 'assets/images/surat_contoh.png';
  static const String docSuratPermohonan = 'assets/images/surat_contoh.png';
  static const String docSusunanPengurus = 'assets/images/surat_contoh.png';
  static const String docBeritaAcara = 'assets/images/surat_contoh.png';
  static const String docDaftarHadir = 'assets/images/surat_contoh.png';
  static const String docSuratDomisili = 'assets/images/surat_contoh.png';
  static const String docKomoditasTernak = 'assets/images/surat_contoh.png';

  // Asset paths - Illustrations (buat Pop-ups)
  // NOTE: Dialog konfirmasi SKT pake gabung_kelompok.png (request user v30.2)
  static const String ilustrasiKonfirmasi =
      'assets/images/gabung_kelompok.png';
  // NOTE: Dialog success/berhasil pake taddaaa_image.png (request user v30.3)
  static const String ilustrasiBerhasil =
      'assets/images/taddaaa_image.png';

  // Splash timings (in milliseconds)
  static const int splashStage1Duration = 800;
  static const int splashStage2Duration = 1200;
  static const int splashStage3Duration = 1500;
  static const int splashTotalDuration = 3500;

  // Animation durations
  static const Duration pageTransition = Duration(milliseconds: 400);
  static const Duration fadeAnimation = Duration(milliseconds: 600);
  static const Duration slideAnimation = Duration(milliseconds: 700);

  // SharedPreferences keys
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keySelectedRole = 'selected_role';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserKelompokId = 'user_kelompok_id';

  // Development flags
  static const bool alwaysShowOnboarding = true;
}

/// Role pengguna
enum UserRole {
  peternak('peternak', 'Peternak'),
  petugasLapangan('petugas_lapangan', 'Petugas Lapangan');

  final String code;
  final String label;
  const UserRole(this.code, this.label);

  static UserRole? fromCode(String? code) {
    if (code == null) return null;
    for (final role in UserRole.values) {
      if (role.code == code) return role;
    }
    return null;
  }
}

/// Jenis ternak
enum JenisTernak {
  sapiPotong('sapi_potong', 'Sapi Potong'),
  sapiPerah('sapi_perah', 'Sapi Perah'),
  kambing('kambing', 'Kambing'),
  domba('domba', 'Domba'),
  ayamPetelur('ayam_petelur', 'Ayam Petelur'),
  ayamPedaging('ayam_pedaging', 'Ayam Pedaging'),
  lainnya('lainnya', 'Lainnya');

  final String code;
  final String label;
  const JenisTernak(this.code, this.label);
}

/// Kondisi umum ternak untuk form SKT
enum KondisiTernak {
  sehat('sehat', 'Sehat'),
  kurangSehat('kurang_sehat', 'Kurang Sehat'),
  sakit('sakit', 'Sakit');

  final String code;
  final String label;
  const KondisiTernak(this.code, this.label);
}

/// Status pengajuan SKT
enum SktStatus {
  draft('draft', 'Draft', 'Lengkapi'),
  diajukan('diajukan', 'Diajukan', 'Menunggu'),
  prosesValidasi('proses_validasi', 'Proses Validasi Isi', 'Proses Validasi Isi'),
  peninjauan('peninjauan', 'Peninjauan Berkas', 'Peninjauan Berkas'),
  perluRevisi('perlu_revisi', 'Perlu Revisi', 'Perlu Revisi'),
  pembuatan('pembuatan', 'Pembuatan Surat SKT', 'Pembuatan Surat'),
  selesai('selesai', 'Selesai', 'Selesai');

  final String code;
  final String label;
  final String shortLabel;
  const SktStatus(this.code, this.label, this.shortLabel);
}
