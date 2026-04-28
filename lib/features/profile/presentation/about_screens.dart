import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/sand_app_bar.dart';

/// Tentang Ternovia — Image 6
class TentangTernoviaScreen extends StatelessWidget {
  const TentangTernoviaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AboutScaffold(
      title: 'Ternovia',
      children: [
        const _AboutHeading('Tentang Ternovia'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Ternovia adalah aplikasi pendamping peternak yang dirancang untuk '
          'membantu pengelolaan ternak menjadi lebih mudah, terstruktur, dan '
          'berbasis data. Melalui Ternovia, peternak dapat memantau kesehatan '
          'ternak, mencatat produksi, mengakses layanan dinas, serta belajar '
          'melalui materi edukasi yang praktis.',
        ),
        const SizedBox(height: AppSpacing.sm),
        const _AboutParagraph(
          'Aplikasi ini hadir untuk mendukung peternak dalam meningkatkan '
          'produktivitas, memperkuat kolaborasi kelompok ternak, dan '
          'mempermudah komunikasi dengan petugas lapangan.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('Misi'),
        const SizedBox(height: AppSpacing.xs),
        const _BulletList([
          'Membantu peternak mengambil keputusan berbasis data.',
          'Mempermudah akses layanan dan informasi peternakan.',
          'Mendukung pertumbuhan peternakan yang berkelanjutan.',
        ]),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('Versi Aplikasi'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph('Versi 1.0.0'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Dikembangkan bersama peternak dan petugas lapangan untuk '
          'kebutuhan nyata di lapangan.',
        ),
      ],
    );
  }
}

/// Kebijakan Privasi — Image 7
class KebijakanPrivasiScreen extends StatelessWidget {
  const KebijakanPrivasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AboutScaffold(
      title: 'Kebijakan Privasi',
      children: [
        const _AboutParagraph(
          'Kami menghargai privasi Anda. Kebijakan ini menjelaskan bagaimana '
          'data Anda dikumpulkan, digunakan, dan dilindungi saat menggunakan '
          'aplikasi Ternovia.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('Data yang Dikumpulkan'),
        const SizedBox(height: AppSpacing.xs),
        const _BulletList([
          'Informasi akun (nama, nomor kontak, email).',
          'Data kelompok dan aktivitas peternakan.',
          'Data penggunaan aplikasi untuk peningkatan layanan.',
        ]),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('Penggunaan Data'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph('Data digunakan untuk:'),
        const SizedBox(height: 4),
        const _BulletList([
          'Memberikan layanan aplikasi.',
          'Memproses layanan peternakan dan bantuan.',
          'Menyediakan analisis serta rekomendasi yang relevan.',
          'Meningkatkan kualitas sistem dan pengalaman pengguna.',
        ]),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('Keamanan Data'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Kami menjaga keamanan data Anda dengan sistem perlindungan yang '
          'sesuai standar dan membatasi akses hanya untuk pihak yang berwenang.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('Berbagi Data'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Data tidak akan dibagikan kepada pihak ketiga tanpa izin, kecuali '
          'untuk kebutuhan layanan resmi yang terkait dengan program peternakan.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('Hak Pengguna'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph('Anda berhak untuk:'),
        const SizedBox(height: 4),
        const _BulletList([
          'Mengakses data pribadi Anda.',
          'Memperbarui informasi akun.',
          'Mengajukan penghapusan akun sesuai ketentuan.',
        ]),
        const SizedBox(height: AppSpacing.md),
        const _AboutParagraph(
          'Dengan menggunakan Ternovia, Anda menyetujui kebijakan privasi ini.',
        ),
      ],
    );
  }
}

/// Panduan Pengguna — Image 8
class PanduanPenggunaScreen extends StatelessWidget {
  const PanduanPenggunaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AboutScaffold(
      title: 'Panduan Pengguna',
      children: [
        const _AboutParagraph(
          'Panduan ini membantu Anda memahami cara menggunakan fitur utama '
          'Ternovia secara sederhana. Ikuti langkah-langkah berikut agar '
          'penggunaan aplikasi lebih optimal.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('1. Mengelola Data Ternak'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Tambahkan kandang atau ternak, lalu lakukan pencatatan kesehatan '
          'dan produksi secara rutin untuk memudahkan pemantauan.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('2. Menggunakan Layanan'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Akses menu Layanan untuk melihat pengajuan SKT, bantuan, atau '
          'sampel pakan serta memantau status prosesnya.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('3. Monitoring Kesehatan & Produksi'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Isi data secara berkala agar aplikasi dapat memberikan analisis dan '
          'rekomendasi yang lebih akurat.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('4. Mengakses Materi Edukasi'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Pelajari artikel, video, dan informasi pasar untuk meningkatkan '
          'pengetahuan peternakan.',
        ),
        const SizedBox(height: AppSpacing.md),
        const _AboutHeading('5. Mengatur Profil'),
        const SizedBox(height: AppSpacing.xs),
        const _AboutParagraph(
          'Sesuaikan pengaturan akun agar informasi penting tidak terlewat.',
        ),
      ],
    );
  }
}

// ============== SHARED WIDGETS ==============

class _AboutScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _AboutScaffold({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SandAppBar(
            title: title,
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppDimensions.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...children,
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutHeading extends StatelessWidget {
  final String text;

  const _AboutHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.headingSmall.copyWith(
        color: AppColors.textDarker,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    );
  }
}

class _AboutParagraph extends StatelessWidget {
  final String text;

  const _AboutParagraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.textDark,
        fontSize: 13,
        height: 1.6,
      ),
      textAlign: TextAlign.justify,
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;

  const _BulletList(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((text) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 7, left: 8, right: 10),
                child: SizedBox(
                  width: 5,
                  height: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.textDarker,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textDark,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
