import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============ ENUMS ============

enum JenisTernak {
  sapiPerah('Sapi Perah Holstein'),
  sapiPotong('Sapi Potong'),
  kambing('Kambing'),
  domba('Domba'),
  ayam('Ayam'),
  bebek('Bebek');

  final String label;
  const JenisTernak(this.label);
}

enum KondisiTernak {
  aktifitas('Aktifitas', Colors.green),
  lesu('Lesu', Colors.orange),
  gelisah('Gelisah', Colors.red);

  final String label;
  final Color color;
  const KondisiTernak(this.label, this.color);
}

enum StatusKesehatan {
  sehat('Sehat', Colors.green),
  perluDicek('Perlu Dicek', Colors.orange),
  sakit('Sakit', Colors.red);

  final String label;
  final Color color;
  const StatusKesehatan(this.label, this.color);
}

// ============ MODELS ============

/// Kandang — parent container untuk kumpulan ternak sejenis
class Kandang {
  final String id;
  final String nama;
  final JenisTernak jenis;
  final int jumlahPopulasi;
  final int jumlahJantan;
  final int jumlahBetina;
  final String umurBatch;
  final int jumlahAwal;
  final int jumlahMati;
  final int jumlahLahir;
  final bool statusAktif;
  final String? fotoPath;
  final String kondisi;
  final double? produksiLiter; // untuk sapi perah

  const Kandang({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.jumlahPopulasi,
    this.jumlahJantan = 0,
    this.jumlahBetina = 0,
    this.umurBatch = '-',
    this.jumlahAwal = 0,
    this.jumlahMati = 0,
    this.jumlahLahir = 0,
    this.statusAktif = true,
    this.fotoPath,
    this.kondisi = 'Sehat',
    this.produksiLiter,
  });

  Kandang copyWith({
    String? nama,
    JenisTernak? jenis,
    int? jumlahPopulasi,
    int? jumlahJantan,
    int? jumlahBetina,
    String? umurBatch,
    int? jumlahAwal,
    int? jumlahMati,
    int? jumlahLahir,
    bool? statusAktif,
    String? fotoPath,
    String? kondisi,
    double? produksiLiter,
  }) =>
      Kandang(
        id: id,
        nama: nama ?? this.nama,
        jenis: jenis ?? this.jenis,
        jumlahPopulasi: jumlahPopulasi ?? this.jumlahPopulasi,
        jumlahJantan: jumlahJantan ?? this.jumlahJantan,
        jumlahBetina: jumlahBetina ?? this.jumlahBetina,
        umurBatch: umurBatch ?? this.umurBatch,
        jumlahAwal: jumlahAwal ?? this.jumlahAwal,
        jumlahMati: jumlahMati ?? this.jumlahMati,
        jumlahLahir: jumlahLahir ?? this.jumlahLahir,
        statusAktif: statusAktif ?? this.statusAktif,
        fotoPath: fotoPath ?? this.fotoPath,
        kondisi: kondisi ?? this.kondisi,
        produksiLiter: produksiLiter ?? this.produksiLiter,
      );
}

/// Ternak individual dalam satu Kandang (e.g. "Sapi Perah #101")
class TernakIndividu {
  final String id;
  final String kandangId;
  final String kodeTernak; // e.g. "Sapi Perah #101"
  final KondisiTernak kondisi;
  final String? catatan;

  const TernakIndividu({
    required this.id,
    required this.kandangId,
    required this.kodeTernak,
    this.kondisi = KondisiTernak.aktifitas,
    this.catatan,
  });
}

// ============ PROVIDERS ============

class KandangNotifier extends StateNotifier<List<Kandang>> {
  KandangNotifier() : super(_dummy);

  static final _dummy = [
    const Kandang(
      id: 'k_001',
      nama: 'Kandang Sapi A',
      jenis: JenisTernak.sapiPerah,
      jumlahPopulasi: 24,
      jumlahJantan: 11,
      jumlahBetina: 13,
      umurBatch: '3 Tahun',
      jumlahAwal: 18,
      jumlahMati: 2,
      jumlahLahir: 6,
      produksiLiter: 10.3,
    ),
    const Kandang(
      id: 'k_002',
      nama: 'Kandang Sapi B',
      jenis: JenisTernak.sapiPerah,
      jumlahPopulasi: 18,
      jumlahJantan: 8,
      jumlahBetina: 10,
      umurBatch: '2 Tahun',
      jumlahAwal: 15,
      jumlahMati: 1,
      jumlahLahir: 4,
      produksiLiter: 10.3,
    ),
  ];

  void tambah(Kandang k) => state = [k, ...state];
  void update(Kandang k) =>
      state = state.map((x) => x.id == k.id ? k : x).toList();
  void hapus(String id) => state = state.where((x) => x.id != id).toList();

  Kandang? getById(String id) {
    try {
      return state.firstWhere((x) => x.id == id);
    } catch (_) {
      return null;
    }
  }
}

final kandangListProvider =
    StateNotifierProvider<KandangNotifier, List<Kandang>>((_) => KandangNotifier());

/// Ternak individu provider — auto generate 10 ternak per kandang sapi
final ternakIndividuProvider = Provider.family<List<TernakIndividu>, String>(
  (ref, kandangId) {
    final kandang = ref.watch(kandangListProvider.notifier).getById(kandangId);
    if (kandang == null) return [];

    // Generate dummy ternak individu (10 ekor per kandang, 1 dengan kondisi gelisah)
    final list = <TernakIndividu>[];
    for (int i = 1; i <= 10; i++) {
      final code = '${kandang.jenis.label} #${100 + i}';
      final isSick = i == 7;
      list.add(TernakIndividu(
        id: '${kandangId}_t_$i',
        kandangId: kandangId,
        kodeTernak: code,
        kondisi: isSick ? KondisiTernak.gelisah : KondisiTernak.aktifitas,
        catatan: isSick ? 'Diare, Minum sedikit' : null,
      ));
    }
    return list;
  },
);

/// Search query untuk list kandang
final kandangSearchProvider = StateProvider<String>((_) => '');

final kandangFilteredProvider = Provider<List<Kandang>>((ref) {
  final list = ref.watch(kandangListProvider);
  final q = ref.watch(kandangSearchProvider).toLowerCase();
  if (q.isEmpty) return list;
  return list
      .where((k) =>
          k.nama.toLowerCase().contains(q) ||
          k.jenis.label.toLowerCase().contains(q))
      .toList();
});
