import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/edukasi/presentation/screens/edukasi_screen.dart';
import '../../features/jadwal/presentation/screens/jadwal_screen.dart';
import '../../features/layanan/presentation/screens/layanan_screen.dart';
import '../../features/notifikasi/presentation/screens/notifikasi_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profil/presentation/screens/profil_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/ternak/presentation/screens/ternak_screen.dart';
import '../../shared/layouts/main_shell.dart';
import '../animations/page_transitions.dart';

/// Application router.
/// Flutter 3.3.0 → gunakan go_router ^5.x (bukan 14.x).
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => AppPageTransitions.fadeSlideUp(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/role-selection',
        pageBuilder: (context, state) => AppPageTransitions.slideHorizontal(
          key: state.pageKey,
          child: const RoleSelectionScreen(),
        ),
      ),

      // Main tabs (wrapped by MainShell with bottom nav)
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
          key: state.pageKey,
          child: const MainShell(currentIndex: 0, child: DashboardScreen()),
        ),
      ),
      GoRoute(
        path: '/ternak',
        pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
          key: state.pageKey,
          child: const MainShell(currentIndex: 1, child: TernakScreen()),
        ),
      ),
      GoRoute(
        path: '/layanan',
        pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
          key: state.pageKey,
          child: const MainShell(currentIndex: 2, child: LayananScreen()),
        ),
      ),
      GoRoute(
        path: '/edukasi',
        pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
          key: state.pageKey,
          child: const MainShell(currentIndex: 3, child: EdukasiScreen()),
        ),
      ),
      GoRoute(
        path: '/profil',
        pageBuilder: (context, state) => AppPageTransitions.fadeOnly(
          key: state.pageKey,
          child: const MainShell(currentIndex: 4, child: ProfilScreen()),
        ),
      ),

      // Non-tab routes
      GoRoute(
        path: '/notifikasi',
        pageBuilder: (context, state) => AppPageTransitions.slideHorizontal(
          key: state.pageKey,
          child: const NotifikasiScreen(),
        ),
      ),
      GoRoute(
        path: '/jadwal',
        pageBuilder: (context, state) => AppPageTransitions.slideHorizontal(
          key: state.pageKey,
          child: const JadwalScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan: ${state.error}')),
    ),
  );
}
