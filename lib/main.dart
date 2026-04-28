import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Reset flags in dev mode so full flow always visible
  if (AppConstants.alwaysShowOnboarding) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyHasSeenOnboarding);
    await prefs.remove(AppConstants.keySelectedRole);
  }

  runApp(const ProviderScope(child: TernoviaApp()));
}

class TernoviaApp extends ConsumerWidget {
  const TernoviaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ScreenUtilInit — reference size dari Figma iPhone (375x812).
    // Semua `.sp / .w / .h / .r` di seluruh app scale proporsional ke
    // ukuran screen actual device.
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: router,
        );
      },
    );
  }
}
