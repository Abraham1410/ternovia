import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import 'kelompok_form_state.dart';

/// Result of validation: null = valid, string = error message.
typedef ValidationResult = String?;

class KelompokFormNotifier extends StateNotifier<KelompokFormState> {
  KelompokFormNotifier() : super(const KelompokFormState());

  // Step 1 setters
  void setNamaKelompok(String value) =>
      state = state.copyWith(namaKelompok: value);
  void setJenisTernak(JenisTernak? value) =>
      state = state.copyWith(jenisTernak: value);
  void setJumlahAnggotaAwal(String value) =>
      state = state.copyWith(jumlahAnggotaAwal: value);
  void setJumlahTernak(String value) =>
      state = state.copyWith(jumlahTernak: value);
  void setDeskripsi(String value) =>
      state = state.copyWith(deskripsi: value);

  // Step 2 setters
  void setProvinsi(String value) =>
      state = state.copyWith(provinsi: value);
  void setKabupaten(String value) =>
      state = state.copyWith(kabupaten: value);
  void setKecamatan(String value) =>
      state = state.copyWith(kecamatan: value);
  void setDesa(String value) => state = state.copyWith(desa: value);
  void setAlamatLengkap(String value) =>
      state = state.copyWith(alamatLengkap: value);

  // Step 3 setters
  void setNamaKetua(String value) =>
      state = state.copyWith(namaKetua: value);
  void setNik(String value) => state = state.copyWith(nik: value);
  void setNoTelepon(String value) =>
      state = state.copyWith(noTelepon: value);
  void setFotoKetua(String? path) {
    if (path == null) {
      state = state.copyWith(clearFoto: true);
    } else {
      state = state.copyWith(fotoKetuaPath: path);
    }
  }

  // Navigation
  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void reset() {
    state = const KelompokFormState();
  }

  /// Validation dengan error message yang spesifik.
  /// Return null = valid, return string = error message.
  ValidationResult validateStep1() {
    if (state.namaKelompok.trim().isEmpty) {
      return 'Nama kelompok tidak boleh kosong';
    }
    if (state.jenisTernak == null) {
      return 'Silakan pilih jenis ternak';
    }
    if (state.jumlahAnggotaAwal.trim().isEmpty) {
      return 'Jumlah anggota awal tidak boleh kosong';
    }
    if (int.tryParse(state.jumlahAnggotaAwal) == null) {
      return 'Jumlah anggota harus berupa angka';
    }
    if (state.jumlahTernak.trim().isEmpty) {
      return 'Jumlah ternak tidak boleh kosong';
    }
    if (int.tryParse(state.jumlahTernak) == null) {
      return 'Jumlah ternak harus berupa angka';
    }
    // Deskripsi opsional
    return null;
  }

  ValidationResult validateStep2() {
    if (state.provinsi.trim().isEmpty) {
      return 'Provinsi tidak boleh kosong';
    }
    if (state.kabupaten.trim().isEmpty) {
      return 'Kabupaten / Kota tidak boleh kosong';
    }
    if (state.kecamatan.trim().isEmpty) {
      return 'Kecamatan tidak boleh kosong';
    }
    if (state.desa.trim().isEmpty) {
      return 'Desa tidak boleh kosong';
    }
    // Alamat lengkap opsional
    return null;
  }

  ValidationResult validateStep3() {
    if (state.namaKetua.trim().isEmpty) {
      return 'Nama ketua kelompok tidak boleh kosong';
    }
    if (state.nik.trim().isEmpty) {
      return 'NIK tidak boleh kosong';
    }
    // Validasi NIK: 16 digit angka
    if (state.nik.length != 16) {
      return 'NIK harus terdiri dari 16 digit';
    }
    if (int.tryParse(state.nik) == null) {
      return 'NIK harus berupa angka';
    }
    if (state.noTelepon.trim().isEmpty) {
      return 'No. telepon tidak boleh kosong';
    }
    if (state.noTelepon.length < 10) {
      return 'No. telepon minimal 10 digit';
    }
    // Foto opsional — tidak divalidasi
    return null;
  }
}

final kelompokFormProvider =
    StateNotifierProvider<KelompokFormNotifier, KelompokFormState>(
  (ref) => KelompokFormNotifier(),
);
