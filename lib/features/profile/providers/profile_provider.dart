import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model data profil user (Peternak Ketua Kelompok).
class UserProfile {
  final String nama;
  final String nomorHp;
  final String email;
  final String nik;
  final String alamat;
  final String roleLabel;
  final String namaKelompok;
  final int jumlahAnggota;
  final int jumlahTernak;

  const UserProfile({
    required this.nama,
    required this.nomorHp,
    required this.email,
    required this.nik,
    required this.alamat,
    required this.roleLabel,
    required this.namaKelompok,
    required this.jumlahAnggota,
    required this.jumlahTernak,
  });

  UserProfile copyWith({
    String? nama,
    String? nomorHp,
    String? email,
    String? nik,
    String? alamat,
    String? roleLabel,
    String? namaKelompok,
    int? jumlahAnggota,
    int? jumlahTernak,
  }) {
    return UserProfile(
      nama: nama ?? this.nama,
      nomorHp: nomorHp ?? this.nomorHp,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      alamat: alamat ?? this.alamat,
      roleLabel: roleLabel ?? this.roleLabel,
      namaKelompok: namaKelompok ?? this.namaKelompok,
      jumlahAnggota: jumlahAnggota ?? this.jumlahAnggota,
      jumlahTernak: jumlahTernak ?? this.jumlahTernak,
    );
  }
}

/// Notifier untuk edit profile data.
class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
      : super(const UserProfile(
          nama: 'Jenoardi',
          nomorHp: '085245336985',
          email: 'jenoardi@gmail.com',
          nik: '3517110362558961',
          alamat: 'Dusun Suko, Desa Sukolilo, Kec. Jombang',
          roleLabel: 'Peternak — Ketua Kelompok',
          namaKelompok: 'Kelompok Ternak Sukses Makmur',
          jumlahAnggota: 8,
          jumlahTernak: 24,
        ));

  void updateProfile({
    String? nama,
    String? nomorHp,
    String? email,
    String? alamat,
  }) {
    state = state.copyWith(
      nama: nama,
      nomorHp: nomorHp,
      email: email,
      alamat: alamat,
    );
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
