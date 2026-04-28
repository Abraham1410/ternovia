import '../../../core/constants/app_constants.dart';

/// Model data untuk kelompok yang sedang dibuat (multi-step form).
class KelompokFormState {
  // Step 1: Informasi Kelompok
  final String namaKelompok;
  final JenisTernak? jenisTernak;
  final String jumlahAnggotaAwal;
  final String jumlahTernak;
  final String deskripsi;

  // Step 2: Lokasi Ternak
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String desa;
  final String alamatLengkap;

  // Step 3: Data Ketua Kelompok
  final String namaKetua;
  final String nik;
  final String noTelepon;

  /// Path ke foto ketua (local file path). Foto OPSIONAL.
  final String? fotoKetuaPath;

  // Current step (1, 2, 3)
  final int currentStep;

  const KelompokFormState({
    this.namaKelompok = '',
    this.jenisTernak,
    this.jumlahAnggotaAwal = '',
    this.jumlahTernak = '',
    this.deskripsi = '',
    this.provinsi = '',
    this.kabupaten = '',
    this.kecamatan = '',
    this.desa = '',
    this.alamatLengkap = '',
    this.namaKetua = '',
    this.nik = '',
    this.noTelepon = '',
    this.fotoKetuaPath,
    this.currentStep = 1,
  });

  KelompokFormState copyWith({
    String? namaKelompok,
    JenisTernak? jenisTernak,
    String? jumlahAnggotaAwal,
    String? jumlahTernak,
    String? deskripsi,
    String? provinsi,
    String? kabupaten,
    String? kecamatan,
    String? desa,
    String? alamatLengkap,
    String? namaKetua,
    String? nik,
    String? noTelepon,
    String? fotoKetuaPath,
    bool clearFoto = false,
    int? currentStep,
  }) {
    return KelompokFormState(
      namaKelompok: namaKelompok ?? this.namaKelompok,
      jenisTernak: jenisTernak ?? this.jenisTernak,
      jumlahAnggotaAwal: jumlahAnggotaAwal ?? this.jumlahAnggotaAwal,
      jumlahTernak: jumlahTernak ?? this.jumlahTernak,
      deskripsi: deskripsi ?? this.deskripsi,
      provinsi: provinsi ?? this.provinsi,
      kabupaten: kabupaten ?? this.kabupaten,
      kecamatan: kecamatan ?? this.kecamatan,
      desa: desa ?? this.desa,
      alamatLengkap: alamatLengkap ?? this.alamatLengkap,
      namaKetua: namaKetua ?? this.namaKetua,
      nik: nik ?? this.nik,
      noTelepon: noTelepon ?? this.noTelepon,
      fotoKetuaPath:
          clearFoto ? null : (fotoKetuaPath ?? this.fotoKetuaPath),
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
