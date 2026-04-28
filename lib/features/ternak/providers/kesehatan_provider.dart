import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'kandang_provider.dart';

// ============ ENUMS ============

enum ModeInput {
  kandang('Mode Kandang', 'Input cepat untuk 1 kandang', Icons.house_outlined),
  individu('Per Individu', 'Input kondisi ternak per individu', Icons.pets_outlined),
  massal('Mode Massal', 'Input kondisi untuk semua ternak', Icons.grain_outlined);

  final String label;
  final String deskripsi;
  final IconData icon;
  const ModeInput(this.label, this.deskripsi, this.icon);
}

enum KondisiUmum { aktifitas, lesu, gelisah }
enum NafsuMakan { normal, berkurang, tidakNafsu }
enum Minum { normal, berkurang }
enum Lingkungan { normal, bauKandang }

enum Gejala {
  batuk('Batuk'),
  diare('Diare'),
  pincang('Pincang'),
  mataBerair('Mata Berair');

  final String label;
  const Gejala(this.label);
}

enum Penanganan {
  sudahVaksinHariIni('Sudah vaksin hari ini'),
  berikanObat('Berikan Obat'),
  tambahkanVitamin('Tambahkan Vitamin'),
  diisolasi('Diisolasi');

  final String label;
  const Penanganan(this.label);
}

// ============ MODELS ============

class RecordKesehatan {
  final String id;
  final String targetId; // kandangId atau ternakId
  final ModeInput mode;
  final DateTime tanggal;
  final KondisiUmum? kondisi;
  final NafsuMakan? nafsu;
  final Minum? minum;
  final double? suhu;
  final double? kelembapan;
  final Set<Lingkungan> lingkungan;
  final Set<Gejala> gejala;
  final Set<Penanganan> penanganan;

  const RecordKesehatan({
    required this.id,
    required this.targetId,
    required this.mode,
    required this.tanggal,
    this.kondisi,
    this.nafsu,
    this.minum,
    this.suhu,
    this.kelembapan,
    this.lingkungan = const {},
    this.gejala = const {},
    this.penanganan = const {},
  });
}

/// Stats summary dashboard kesehatan
class KesehatanStats {
  final int total;
  final int sehat;
  final int perluDicek;
  final int sakit;
  final double persenSehat;

  const KesehatanStats({
    required this.total,
    required this.sehat,
    required this.perluDicek,
    required this.sakit,
    required this.persenSehat,
  });
}

/// Data point untuk bar chart (per periode)
class GrafikKesehatanPoint {
  final int periode; // 1,2,3,4 (minggu ke-)
  final double suhuValue; // normalized 0-50
  final double kasusValue;
  final double mortalitasValue;

  const GrafikKesehatanPoint({
    required this.periode,
    required this.suhuValue,
    required this.kasusValue,
    required this.mortalitasValue,
  });
}

// ============ PROVIDERS ============

class KesehatanNotifier extends StateNotifier<List<RecordKesehatan>> {
  KesehatanNotifier() : super([]);

  void tambah(RecordKesehatan r) => state = [r, ...state];
}

final recordKesehatanProvider =
    StateNotifierProvider<KesehatanNotifier, List<RecordKesehatan>>(
  (_) => KesehatanNotifier(),
);

/// Stats dari seluruh kandang
final kesehatanStatsProvider = Provider<KesehatanStats>((ref) {
  final kandangList = ref.watch(kandangListProvider);
  final total = kandangList.fold<int>(0, (s, k) => s + k.jumlahPopulasi);
  // Dummy breakdown: 82% sehat, 2 perlu dicek, 1 sakit
  const perluDicek = 2;
  const sakit = 1;
  final sehat = total - perluDicek - sakit;
  final persen = total > 0 ? (sehat / total * 100) : 0;
  return KesehatanStats(
    total: total,
    sehat: sehat,
    perluDicek: perluDicek,
    sakit: sakit,
    persenSehat: persen.toDouble(),
  );
});

/// Dummy data grafik 4 minggu
final grafikKesehatanProvider = Provider<List<GrafikKesehatanPoint>>((_) {
  return [
    const GrafikKesehatanPoint(
        periode: 1, suhuValue: 30, kasusValue: 12, mortalitasValue: 4),
    const GrafikKesehatanPoint(
        periode: 2, suhuValue: 18, kasusValue: 8, mortalitasValue: 3),
    const GrafikKesehatanPoint(
        periode: 3, suhuValue: 31, kasusValue: 14, mortalitasValue: 3),
    const GrafikKesehatanPoint(
        periode: 4, suhuValue: 20, kasusValue: 7, mortalitasValue: 1),
  ];
});

/// Filter untuk Grafik Utama di Tab Kesehatan.
/// Dipake buat nampilin subset bar (Semua / Suhu / Kasus Sakit / Mortalitas).
enum GrafikFilter {
  semua('Semua'),
  suhu('Suhu'),
  kasus('Kasus Sakit'),
  mortalitas('Mortalitas');

  final String label;
  const GrafikFilter(this.label);
}

/// State provider untuk filter aktif Grafik Utama.
/// Default ke GrafikFilter.semua.
final grafikFilterProvider = StateProvider<GrafikFilter>(
  (_) => GrafikFilter.semua,
);
