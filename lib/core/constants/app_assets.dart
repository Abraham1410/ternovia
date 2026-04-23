class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';
  static const String _animations = 'assets/animations';

  // Logo
  static const String logo = '$_images/logo_ternovia.png';
  static const String logoIcon = '$_images/logo_icon.png';

  // Onboarding
  static const String onboardingHero = '$_images/onboarding_hero.png';

  // Illustrations
  static const String illustrationFarmer = '$_images/illustration_farmer.png';
  static const String illustrationEmptyBookmark = '$_images/illustration_empty_bookmark.png';
  static const String illustrationSuccess = '$_images/illustration_success.png';

  // Animations (Lottie)
  static const String loadingAnim = '$_animations/loading.json';
  static const String successAnim = '$_animations/success.json';
}

class AppConstants {
  AppConstants._();

  static const String appName = 'Ternovia';
  static const String appTagline = 'Dinas Peternakan Kabupaten Jombang';
  static const String appVersion = '1.0.0';

  // Onboarding
  static const String onboardingWelcomeTitle = 'Selamat Datang!';
  static const String onboardingWelcomeSubtitle =
      'Mulai cara baru kelola ternak dengan lebih mudah dan teratur.';
}
