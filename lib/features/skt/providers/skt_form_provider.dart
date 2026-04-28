import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import 'skt_form_state.dart';

/// ValidationResult: null = valid, String = error message.
typedef SktValidationResult = String?;

class SktFormNotifier extends StateNotifier<SktFormState> {
  SktFormNotifier() : super(const SktFormState());

  // ===== Step 1 =====
  void setNamaKelompok(String v) =>
      state = state.copyWith(namaKelompok: v);
  void setAlamatKelompok(String v) =>
      state = state.copyWith(alamatKelompok: v);
  void setDesaKecamatan(String v) =>
      state = state.copyWith(desaKecamatan: v);
  void setKabupaten(String v) =>
      state = state.copyWith(kabupaten: v);
  void setProvinsi(String v) => state = state.copyWith(provinsi: v);

  // ===== Step 2 =====
  void setNamaKetua(String v) =>
      state = state.copyWith(namaKetua: v);
  void setNomorHp(String v) => state = state.copyWith(nomorHp: v);
  void setNikKetua(String v) => state = state.copyWith(nikKetua: v);
  void setJumlahAnggota(String v) =>
      state = state.copyWith(jumlahAnggota: v);

  // ===== Step 3 =====
  void setJenisTernak(JenisTernak? v) =>
      state = state.copyWith(jenisTernak: v);
  void setJumlahTernak(String v) =>
      state = state.copyWith(jumlahTernak: v);
  void setLokasiKandang(String v) =>
      state = state.copyWith(lokasiKandang: v);
  void setKondisiUmum(KondisiTernak? v) =>
      state = state.copyWith(kondisiUmum: v);

  // ===== Step 4: Dokumen =====
  void setDokumen(SktDokumenType type, DokumenFile file) {
    final updated = Map<String, DokumenFile>.from(state.dokumenFiles);
    updated[type.code] = file;
    state = state.copyWith(dokumenFiles: updated);
  }

  void removeDokumen(SktDokumenType type) {
    final updated = Map<String, DokumenFile>.from(state.dokumenFiles);
    updated.remove(type.code);
    state = state.copyWith(dokumenFiles: updated);
  }

  // ===== Navigation =====
  void nextStep() {
    if (state.currentStep < 5) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 5) {
      state = state.copyWith(currentStep: step);
    }
  }

  void reset() {
    state = const SktFormState();
  }

  /// Load dari draft (overwrite state dengan full form state dari draft).
  /// Set draftId biar kalau user save lagi, bisa update draft yang sama.
  void loadFromDraft(SktDraft draft) {
    state = draft.formState.copyWith(
      draftId: draft.id,
    );
  }

  /// Legacy — untuk backward compat kalau ada yang panggil loadDraft(state)
  void loadDraft(SktFormState data) {
    state = data;
  }

  /// Start revision mode untuk pengajuan yang ditolak.
  /// Pre-fill state dari data existing + flag revisionMode.
  /// Langsung jump ke step 4 (dokumentasi) karena cuma dokumen yang perlu diubah.
  void startRevision({
    required String pengajuanId,
    required Map<String, String> revisionNotes,
    required Map<String, DokumenFile> existingDokumenFiles,
  }) {
    // Hapus dokumen yang perlu direvisi dari dokumenFiles
    // biar user wajib upload ulang
    final cleanedFiles = Map<String, DokumenFile>.from(existingDokumenFiles);
    for (final code in revisionNotes.keys) {
      cleanedFiles.remove(code);
    }

    state = SktFormState(
      namaKelompok: 'Kelompok Ternak Sukses Makmur',
      alamatKelompok: 'Dusun Suko',
      desaKecamatan: 'Desa Sukolilo, Kec. Jombang',
      kabupaten: 'Jombang',
      provinsi: 'Jawa Timur',
      namaKetua: 'Jenoardi',
      nomorHp: '085245336985',
      nikKetua: '3517110362558961',
      jumlahAnggota: '8',
      jenisTernak: JenisTernak.sapiPerah,
      jumlahTernak: '24',
      lokasiKandang: 'Dusun Suko',
      kondisiUmum: KondisiTernak.sehat,
      dokumenFiles: cleanedFiles,
      currentStep: 4,
      revisionMode: true,
      pengajuanId: pengajuanId,
      revisionNotes: revisionNotes,
    );
  }

  // ===== Validation =====
  SktValidationResult validateStep1() {
    if (state.alamatKelompok.trim().isEmpty) {
      return 'Alamat kelompok tidak boleh kosong';
    }
    if (state.desaKecamatan.trim().isEmpty) {
      return 'Desa / Kecamatan tidak boleh kosong';
    }
    if (state.kabupaten.trim().isEmpty) {
      return 'Kabupaten tidak boleh kosong';
    }
    if (state.provinsi.trim().isEmpty) {
      return 'Provinsi tidak boleh kosong';
    }
    return null;
  }

  SktValidationResult validateStep2() {
    if (state.namaKetua.trim().isEmpty) {
      return 'Nama ketua kelompok tidak boleh kosong';
    }
    if (state.nomorHp.trim().isEmpty) {
      return 'Nomor HP / WhatsApp tidak boleh kosong';
    }
    if (state.nomorHp.length < 10) {
      return 'Nomor HP minimal 10 digit';
    }
    if (state.nikKetua.trim().isEmpty) {
      return 'NIK tidak boleh kosong';
    }
    if (state.nikKetua.length != 16) {
      return 'NIK harus terdiri dari 16 digit';
    }
    if (state.jumlahAnggota.trim().isEmpty) {
      return 'Jumlah anggota tidak boleh kosong';
    }
    if (int.tryParse(state.jumlahAnggota) == null) {
      return 'Jumlah anggota harus berupa angka';
    }
    return null;
  }

  SktValidationResult validateStep3() {
    if (state.jenisTernak == null) {
      return 'Silakan pilih jenis ternak';
    }
    if (state.jumlahTernak.trim().isEmpty) {
      return 'Jumlah ternak tidak boleh kosong';
    }
    if (int.tryParse(state.jumlahTernak) == null) {
      return 'Jumlah ternak harus berupa angka';
    }
    if (state.lokasiKandang.trim().isEmpty) {
      return 'Lokasi kandang tidak boleh kosong';
    }
    if (state.kondisiUmum == null) {
      return 'Silakan pilih kondisi ternak';
    }
    return null;
  }

  SktValidationResult validateStep4() {
    // Minimal 3 dokumen wajib (surat permohonan, susunan pengurus, ktp)
    final requiredDocs = [
      SktDokumenType.suratPermohonan,
      SktDokumenType.susunanPengurus,
      SktDokumenType.ktpAnggota,
    ];
    for (final doc in requiredDocs) {
      if (!state.dokumenFiles.containsKey(doc.code)) {
        return 'Dokumen "${doc.label}" belum di-upload';
      }
    }
    return null;
  }
}

final sktFormProvider =
    StateNotifierProvider<SktFormNotifier, SktFormState>(
  (ref) => SktFormNotifier(),
);

/// Provider buat list riwayat pengajuan SKT (dummy data dulu).
final sktRiwayatProvider =
    StateProvider<List<SktPengajuan>>((ref) {
  return [
    SktPengajuan(
      id: 'skt_001',
      namaKelompok: 'Pengajuan SKT',
      jumlahDokumen: 8,
      tanggalKirim: DateTime(2026, 1, 2),
      status: SktStatus.prosesValidasi,
    ),
    SktPengajuan(
      id: 'skt_002',
      namaKelompok: 'Pengajuan SKT',
      jumlahDokumen: 6,
      tanggalKirim: DateTime(2026, 1, 5),
      status: SktStatus.perluRevisi,
      tanggalRevisi: DateTime(2026, 1, 8),
      revisionNotes: const [
        RevisionNote(
          dokumenCode: 'surat_permohonan',
          dokumenLabel: 'Surat Permohonan SKT',
          catatan:
              'Stempel kelompok belum jelas. Mohon upload ulang dengan foto yang lebih terang.',
        ),
        RevisionNote(
          dokumenCode: 'ktp_anggota',
          dokumenLabel: 'KTP Anggota',
          catatan:
              'File KTP belum lengkap. Pastikan gabungkan KTP ketua + semua anggota dalam 1 PDF.',
        ),
      ],
    ),
    SktPengajuan(
      id: 'skt_003',
      namaKelompok: 'Pengajuan SKT',
      jumlahDokumen: 8,
      tanggalKirim: DateTime(2025, 12, 28),
      status: SktStatus.selesai,
    ),
  ];
});

/// Provider buat list draft SKT (dummy data).
final sktDraftProvider = StateProvider<List<SktDraft>>((ref) {
  return [
    SktDraft(
      id: 'draft_001',
      namaKelompok: 'Draft Kelompok Sukses Makmur',
      tanggalSimpan: DateTime(2026, 1, 3),
      formState: const SktFormState(
        namaKelompok: 'Kelompok Ternak Sukses Makmur',
        alamatKelompok: 'Dusun Suko',
        desaKecamatan: 'Desa Sukolilo, Kec. Jombang',
        kabupaten: 'Jombang',
        provinsi: 'Jawa Timur',
        namaKetua: 'Jenoardi',
        nomorHp: '085245336985',
        nikKetua: '3517110362558961',
        jumlahAnggota: '8',
        currentStep: 3, // user stopped at step 3
      ),
    ),
  ];
});
