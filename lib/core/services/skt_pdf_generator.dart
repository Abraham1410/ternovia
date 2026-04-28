import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../features/skt/providers/skt_form_state.dart';

/// Generator PDF untuk Surat Keterangan Terdaftar (SKT).
///
/// Generate PDF dengan layout resmi:
/// - Header: logo placeholder + "DINAS PETERNAKAN KABUPATEN JOMBANG"
/// - Title: "SURAT KETERANGAN TERDAFTAR"
/// - Nomor surat
/// - Isi: data kelompok + anggota + ternak
/// - Tanggal + tanda tangan placeholder
class SktPdfGenerator {
  SktPdfGenerator._();

  /// Generate file PDF SKT dan simpan ke app docs dir.
  /// Return path ke file PDF yang udah di-generate.
  static Future<String> generate({
    required SktPengajuan pengajuan,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              pw.SizedBox(height: 20),
              _buildTitle(pengajuan),
              pw.SizedBox(height: 28),
              _buildIntro(),
              pw.SizedBox(height: 14),
              _buildDataKelompok(),
              pw.SizedBox(height: 18),
              _buildKeterangan(),
              pw.SizedBox(height: 24),
              _buildPenutup(),
              pw.SizedBox(height: 40),
              _buildSignature(pengajuan),
            ],
          );
        },
      ),
    );

    // Save to app docs
    final appDocsDir = await getApplicationDocumentsDirectory();
    final outputDir = Directory('${appDocsDir.path}/skt_output');
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath =
        '${outputDir.path}/SKT_${pengajuan.id}_$timestamp.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  // ============ Sections ============

  static pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 60,
          height: 60,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1.5),
            shape: pw.BoxShape.circle,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text(
            'LOGO',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'PEMERINTAH KABUPATEN JOMBANG',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          'DINAS PETERNAKAN DAN KESEHATAN HEWAN',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          'Jl. Raya Mojoagung No. 99, Jombang — Jawa Timur',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.Text(
          'Telp: (0321) 861-xxx | Email: disnakkan@jombangkab.go.id',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 8),
        pw.Container(height: 2, color: PdfColors.black),
        pw.SizedBox(height: 1),
        pw.Container(height: 0.5, color: PdfColors.black),
      ],
    );
  }

  static pw.Widget _buildTitle(SktPengajuan pengajuan) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'SURAT KETERANGAN TERDAFTAR',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            decoration: pw.TextDecoration.underline,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Nomor: 524/SKT/${_formatNoSurat(pengajuan)}/DNK-JBG/${DateTime.now().year}',
          style: const pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  static pw.Widget _buildIntro() {
    return pw.Text(
      'Yang bertanda tangan di bawah ini, Kepala Dinas Peternakan dan Kesehatan Hewan '
      'Kabupaten Jombang, dengan ini menerangkan bahwa:',
      style: const pw.TextStyle(fontSize: 11),
      textAlign: pw.TextAlign.justify,
    );
  }

  static pw.Widget _buildDataKelompok() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 24),
      child: pw.Column(
        children: [
          _buildDataRow('Nama Kelompok', 'Kelompok Ternak Sukses Makmur'),
          _buildDataRow('Nama Ketua', 'Jenoardi'),
          _buildDataRow('NIK Ketua', '3517110362558961'),
          _buildDataRow('Alamat Kelompok',
              'Dusun Suko, Desa Sukolilo, Kec. Jombang, Kab. Jombang, Jawa Timur'),
          _buildDataRow('Jumlah Anggota', '8 orang'),
          _buildDataRow('Jenis Ternak', 'Sapi Perah'),
          _buildDataRow('Jumlah Ternak', '24 ekor'),
          _buildDataRow('Lokasi Kandang', 'Dusun Suko, Desa Sukolilo'),
        ],
      ),
    );
  }

  static pw.Widget _buildDataRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 130,
            child: pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
          pw.Text(
            ' : ',
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildKeterangan() {
    return pw.Text(
      'Benar terdaftar sebagai Kelompok Ternak di wilayah Kabupaten Jombang dan telah '
      'memenuhi persyaratan administratif sebagaimana diatur dalam ketentuan yang berlaku. '
      'Kelompok ini dinyatakan terdaftar secara resmi dan berhak memperoleh pembinaan serta '
      'dapat mengajukan berbagai program bantuan yang diselenggarakan oleh Dinas Peternakan '
      'dan Kesehatan Hewan Kabupaten Jombang.',
      style: const pw.TextStyle(fontSize: 11),
      textAlign: pw.TextAlign.justify,
    );
  }

  static pw.Widget _buildPenutup() {
    return pw.Text(
      'Surat Keterangan Terdaftar ini berlaku selama 2 (dua) tahun sejak tanggal diterbitkan '
      'dan dapat diperpanjang. Demikian surat keterangan ini dibuat untuk dapat dipergunakan '
      'sebagaimana mestinya.',
      style: const pw.TextStyle(fontSize: 11),
      textAlign: pw.TextAlign.justify,
    );
  }

  static pw.Widget _buildSignature(SktPengajuan pengajuan) {
    final today = DateTime.now();
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'Jombang, ${_formatDateIndo(today)}',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.Text(
              'Kepala Dinas Peternakan & Kesehatan Hewan',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.Text(
              'Kabupaten Jombang',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 50),
            pw.Container(
              width: 180,
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 1),
                ),
              ),
              child: pw.Text(
                'Dr. Ir. H. Suharto, M.Si.',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Text(
              'NIP. 19650812 199303 1 005',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  static String _formatNoSurat(SktPengajuan pengajuan) {
    final num = pengajuan.id.hashCode.abs() % 9999;
    return num.toString().padLeft(4, '0');
  }

  static String _formatDateIndo(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}
