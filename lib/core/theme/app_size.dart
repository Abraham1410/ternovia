import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive size utilities using flutter_screenutil.
/// Reference size: 375x812 (iPhone Figma design).
///
/// Usage:
///   ```dart
///   padding: EdgeInsets.all(AppSize.md)  // responsive 16.w
///   fontSize: AppSize.fs14               // responsive 14.sp
///   ```
///
/// Naming convention (aligned with AppSpacing):
/// - `xxs` = 4, `xs` = 8, `sm` = 12, `md` = 16, `lg` = 20, `xl` = 24,
///   `xxl` = 32, `xxxl` = 40, `huge` = 48, `massive` = 64
///
/// Font sizes: `fs10`..`fs22` (common sizes in the app).
///
/// This class is intentionally additive — existing `AppSpacing` / `AppRadius`
/// / `AppDimensions` tetap ada untuk backward compat. Widget baru boleh pake
/// `AppSize` untuk responsive, widget lama tetap pake `AppSpacing` dll.
class AppSize {
  AppSize._();

  // ===== Spacing (width-based scaling) =====
  static double get xxs => 4.w;
  static double get xs => 8.w;
  static double get sm => 12.w;
  static double get md => 16.w;
  static double get lg => 20.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;
  static double get xxxl => 40.w;
  static double get huge => 48.w;
  static double get massive => 64.w;

  // ===== Height-specific (use for vertical spacing where height-scale matters) =====
  static double get hxs => 8.h;
  static double get hsm => 12.h;
  static double get hmd => 16.h;
  static double get hlg => 20.h;
  static double get hxl => 24.h;

  // ===== Radius =====
  static double get rSm => 8.r;
  static double get rMd => 12.r;
  static double get rLg => 16.r;
  static double get rXl => 20.r;
  static double get rXxl => 24.r;
  static double get rCard => 20.r;
  static double get rButton => 999.r; // pill
  static double get rInput => 12.r;

  // ===== Font sizes =====
  static double get fs10 => 10.sp;
  static double get fs11 => 11.sp;
  static double get fs12 => 12.sp;
  static double get fs13 => 13.sp;
  static double get fs14 => 14.sp;
  static double get fs15 => 15.sp;
  static double get fs16 => 16.sp;
  static double get fs17 => 17.sp;
  static double get fs18 => 18.sp;
  static double get fs20 => 20.sp;
  static double get fs22 => 22.sp;

  // ===== Dimensions =====
  static double get screenPaddingH => 24.w;
  static double get buttonHeight => 48.h;
  static double get inputHeight => 48.h;
  static double get appBarHeight => 56.h;

  // ===== Icon sizes =====
  static double get iconSm => 16.sp;
  static double get iconMd => 20.sp;
  static double get iconLg => 24.sp;
  static double get iconXl => 32.sp;
}
