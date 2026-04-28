import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data point untuk chart produksi (per hari dalam seminggu atau bulan)
class ProduksiPoint {
  final String label; // "Sen", "Sel", ... atau "Jan", "Feb"
  final double liter;

  const ProduksiPoint({required this.label, required this.liter});
}

/// Record produksi — per input batch
class RecordProduksi {
  final String id;
  final String batchId; // kandangId
  final DateTime tanggal;
  final double jumlahTotal;
  final double kualitasLayak;
  final double kualitasTidakLayak;
  final String? catatan;

  const RecordProduksi({
    required this.id,
    required this.batchId,
    required this.tanggal,
    required this.jumlahTotal,
    required this.kualitasLayak,
    required this.kualitasTidakLayak,
    this.catatan,
  });
}

class ProduksiStats {
  final double literHariIni;
  final int sapiAktif;
  final bool panenHariIni;
  final double literBulanIni;
  final String namaBulan;

  const ProduksiStats({
    required this.literHariIni,
    required this.sapiAktif,
    required this.panenHariIni,
    required this.literBulanIni,
    required this.namaBulan,
  });
}

// ============ PROVIDERS ============

class ProduksiNotifier extends StateNotifier<List<RecordProduksi>> {
  ProduksiNotifier() : super(_dummy);

  static final _dummy = List.generate(10, (i) {
    final liter = [25.0, 27.0, 26.0, 20.0, 28.0, 20.0, 24.0, 20.0, 27.0, 25.0][i];
    final catatan = [
      'Produksi menurun',
      'Produksi normal',
      'Produksi stabil',
      'Ada susu sedikit',
      'Produksi optimal',
      'Susu sedikit encer',
      'Kualitas susu bagus',
      'Produksi menurun',
      'Produksi stabil',
      'Produksi stabil',
    ][i];
    return RecordProduksi(
      id: 'p_$i',
      batchId: 'k_001',
      tanggal: DateTime(2026, 2, 12),
      jumlahTotal: liter,
      kualitasLayak: liter,
      kualitasTidakLayak: i == 4 ? 2 : liter,
      catatan: catatan,
    );
  });

  void tambah(RecordProduksi r) => state = [r, ...state];
}

final produksiListProvider =
    StateNotifierProvider<ProduksiNotifier, List<RecordProduksi>>(
  (_) => ProduksiNotifier(),
);

final produksiStatsProvider = Provider<ProduksiStats>((_) {
  return const ProduksiStats(
    literHariIni: 23,
    sapiAktif: 15,
    panenHariIni: true,
    literBulanIni: 1840,
    namaBulan: 'Februari 2026',
  );
});

/// Data chart mingguan (Sen-Ming)
final produksiMingguanProvider = Provider<List<ProduksiPoint>>((_) {
  return const [
    ProduksiPoint(label: 'Sen', liter: 30),
    ProduksiPoint(label: 'Sel', liter: 30),
    ProduksiPoint(label: 'Rab', liter: 25),
    ProduksiPoint(label: 'Kam', liter: 30),
    ProduksiPoint(label: 'Jum', liter: 25),
    ProduksiPoint(label: 'Sab', liter: 25),
    ProduksiPoint(label: 'Ming', liter: 25),
  ];
});

/// Data chart bulanan
final produksiBulananProvider = Provider<List<ProduksiPoint>>((_) {
  return const [
    ProduksiPoint(label: 'Jan', liter: 35),
    ProduksiPoint(label: 'Feb', liter: 40),
    ProduksiPoint(label: 'Mar', liter: 32),
    ProduksiPoint(label: 'Apr', liter: 38),
    ProduksiPoint(label: 'Mei', liter: 42),
    ProduksiPoint(label: 'Jun', liter: 36),
  ];
});
