import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pilih_peran_screen.dart';
import '../../features/kelompok/presentation/bagikan_kode_screen.dart';
import '../../features/kelompok/presentation/kelompok_berhasil_screen.dart';
import '../../features/kelompok/presentation/kelompok_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/pdf_viewer/presentation/pdf_viewer_screen.dart';
import '../../features/profile/presentation/about_screens.dart';
import '../../features/profile/presentation/dokumen_saya_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/kata_sandi_screen.dart';
import '../../features/profile/presentation/kelola_kelompok_screen.dart';
import '../../features/profile/presentation/profile_detail_screen.dart';
import '../../features/shell/shell_scaffold.dart';
import '../../features/ternak/presentation/detail_kesehatan_ternak_screen.dart';
import '../../features/ternak/presentation/detail_ternak_screen.dart';
import '../../features/ternak/presentation/input_kesehatan_screen.dart';
import '../../features/ternak/presentation/input_produksi_screen.dart';
import '../../features/ternak/presentation/kandang_detail_screen.dart';
import '../../features/ternak/presentation/laporan_kunjungan_screen.dart';
import '../../features/ternak/presentation/tambah_kandang_screen.dart';
import '../../features/ternak/providers/kesehatan_provider.dart';
import '../../features/skt/presentation/skt_detail_screen.dart';
import '../../features/skt/presentation/skt_form_screen.dart';
import '../../features/skt/presentation/skt_main_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

CustomTransitionPage<T> _buildFadePage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    transitionDuration: AppConstants.pageTransition,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      );
    },
  );
}

/// Router config.
///
/// Full flow:
/// / (splash)
///   → /onboarding
///     → /pilih-peran
///       Peternak:
///         → /kelompok (tab Buat vs Gabung)
///           Buat submit → /kelompok-berhasil?kode=XXX
///                       → /bagikan-kode?kode=XXX (tap "Undang Anggota")
///                       → /dashboard (tap "Lewati")
///           Gabung submit → (modal sukses) → [nanti ke dashboard anggota]
///       Petugas: → /login/petugas (placeholder)
///
/// Main app (after auth):
/// /dashboard (shell with bottom nav)
///   Tab 0: Beranda (Dashboard)
///   Tab 1: Ternak (placeholder)
///   Tab 2: Layanan
///   Tab 3: Edukasi (placeholder)
///   Tab 4: Profil (placeholder)
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/pilih-peran',
        name: 'pilih-peran',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const PilihPeranScreen(),
        ),
      ),
      GoRoute(
        path: '/kelompok',
        name: 'kelompok',
        pageBuilder: (context, state) {
          final tabParam = state.uri.queryParameters['tab'];
          final initialTab = int.tryParse(tabParam ?? '0') ?? 0;
          return _buildFadePage(
            key: state.pageKey,
            child: KelompokScreen(initialTab: initialTab),
          );
        },
      ),
      GoRoute(
        path: '/kelompok-berhasil',
        name: 'kelompok-berhasil',
        pageBuilder: (context, state) {
          final kode = state.uri.queryParameters['kode'];
          return _buildFadePage(
            key: state.pageKey,
            child: KelompokBerhasilScreen(kodeUndangan: kode),
          );
        },
      ),
      GoRoute(
        path: '/bagikan-kode',
        name: 'bagikan-kode',
        pageBuilder: (context, state) {
          final kode = state.uri.queryParameters['kode'] ?? 'TN-00000';
          return _buildFadePage(
            key: state.pageKey,
            child: BagikanKodeScreen(kode: kode),
          );
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) {
          final tabParam = state.uri.queryParameters['tab'];
          final initialTab = int.tryParse(tabParam ?? '0') ?? 0;
          return _buildFadePage(
            key: state.pageKey,
            child: ShellScaffold(initialTab: initialTab),
          );
        },
      ),
      // ========== SKT Routes ==========
      GoRoute(
        path: '/layanan/skt',
        name: 'skt-main',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const SktMainScreen(),
        ),
        routes: [
          GoRoute(
            path: 'form',
            name: 'skt-form',
            pageBuilder: (context, state) => _buildFadePage(
              key: state.pageKey,
              child: const SktFormScreen(),
            ),
          ),
          GoRoute(
            path: 'detail/:id',
            name: 'skt-detail',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return _buildFadePage(
                key: state.pageKey,
                child: SktDetailScreen(pengajuanId: id),
              );
            },
          ),
        ],
      ),
      // ========== PDF Viewer Route ==========
      GoRoute(
        path: '/pdf-viewer',
        name: 'pdf-viewer',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          final filePath = extra?['filePath'] ?? '';
          final fileName = extra?['fileName'] ?? 'Dokumen.pdf';
          return _buildFadePage(
            key: state.pageKey,
            child: PdfViewerScreen(
              filePath: filePath,
              fileName: fileName,
            ),
          );
        },
      ),
      // ========== Ternak Routes ==========
      GoRoute(
        path: '/ternak/tambah-kandang',
        name: 'ternak-tambah-kandang',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const TambahKandangScreen(),
        ),
      ),
      GoRoute(
        path: '/ternak/kandang/:id',
        name: 'ternak-kandang-detail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _buildFadePage(
            key: state.pageKey,
            child: KandangDetailScreen(kandangId: id),
          );
        },
      ),
      GoRoute(
        path: '/ternak/kandang/:id/detail-ternak',
        name: 'ternak-detail-list',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _buildFadePage(
            key: state.pageKey,
            child: DetailTernakScreen(kandangId: id),
          );
        },
      ),
      GoRoute(
        path: '/ternak/input-kesehatan',
        name: 'ternak-input-kesehatan',
        pageBuilder: (context, state) {
          final mode = state.extra as ModeInput? ?? ModeInput.individu;
          return _buildFadePage(
            key: state.pageKey,
            child: InputKesehatanScreen(mode: mode),
          );
        },
      ),
      GoRoute(
        path: '/ternak/laporan-kunjungan',
        name: 'ternak-laporan-kunjungan',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const LaporanKunjunganScreen(),
        ),
      ),
      GoRoute(
        path: '/ternak/input-produksi',
        name: 'ternak-input-produksi',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const InputProduksiScreen(),
        ),
      ),
      GoRoute(
        path: '/ternak/detail-kesehatan',
        name: 'ternak-detail-kesehatan',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const DetailKesehatanTernakScreen(),
        ),
      ),
      // ========== Profile Routes ==========
      GoRoute(
        path: '/profil/edit',
        name: 'profil-edit',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/profil/detail',
        name: 'profil-detail',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const ProfileDetailScreen(),
        ),
      ),
      GoRoute(
        path: '/profil/kata-sandi',
        name: 'profil-kata-sandi',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const KataSandiScreen(),
        ),
      ),
      GoRoute(
        path: '/profil/tentang',
        name: 'profil-tentang',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const TentangTernoviaScreen(),
        ),
      ),
      GoRoute(
        path: '/profil/privasi',
        name: 'profil-privasi',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const KebijakanPrivasiScreen(),
        ),
      ),
      GoRoute(
        path: '/profil/panduan',
        name: 'profil-panduan',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const PanduanPenggunaScreen(),
        ),
      ),
      GoRoute(
        path: '/profil/dokumen',
        name: 'profil-dokumen',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const DokumenSayaScreen(),
        ),
      ),
      GoRoute(
        path: '/profil/kelompok',
        name: 'profil-kelompok',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const KelolaKelompokScreen(),
        ),
      ),
      GoRoute(
        path: '/login/petugas',
        name: 'login-petugas',
        builder: (context, state) => const _PlaceholderScreen(
          title: 'Login Petugas Lapangan',
          message:
              'Screen ini akan di-implementasi di session berikutnya.\n\nFlow Petugas Lapangan belum masuk prioritas, kita fokus ke Peternak dulu.',
        ),
      ),
    ],
  );
});

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;

  const _PlaceholderScreen({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: Text(
          title,
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pilih-peran'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: () => context.go('/pilih-peran'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

