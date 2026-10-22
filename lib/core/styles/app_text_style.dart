import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_font_size.dart';

class AppTextStyle {
  /// Plus Jakarta Sans (variable) for titles and figures.
  static TextStyle _display(double size, double weight, {double? height, double? letterSpacing}) => TextStyle(
        fontFamily: "Plus Jakarta Sans",
        fontFamilyFallback: const ["Inter"],
        fontSize: size,
        fontWeight: FontWeight.values[((weight / 100).round() - 1).clamp(0, 8)],
        fontVariations: [FontVariation('wght', weight)],
        color: AppColors.foreground,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle xxSmall = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.xxSmall,
    color: AppColors.foreground,
  );

  static TextStyle xSmall = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.xSmall,
    color: AppColors.foreground,
  );

  static TextStyle small = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.small,
    color: AppColors.foreground,
  );

  static TextStyle medium = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.medium,
    color: AppColors.foreground,
    fontWeight: FontWeight.normal,
  );

  static TextStyle large = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.large,
    color: AppColors.foreground,
    fontWeight: FontWeight.normal,
  );

  static TextStyle xLarge = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.xLarge,
    color: AppColors.foreground,
    fontWeight: FontWeight.normal,
  );

  static TextStyle xxLarge = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.xxLarge,
    color: AppColors.foreground,
    fontWeight: FontWeight.normal,
  );

  static TextStyle xxxLarge = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.xxxLarge,
    color: AppColors.foreground,
    fontWeight: FontWeight.normal,
  );

  static TextStyle xxxxLarge = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.xxxxLarge,
    color: AppColors.foreground,
    fontWeight: FontWeight.normal,
  );

  static TextStyle xxxxxLarge = TextStyle(
    fontFamily: "Inter",
    fontSize: AppFontSize.xxxxxLarge,
    color: AppColors.foreground,
    fontWeight: FontWeight.normal,
  );

  // Semantic styles used across the three role shells.

  /// Hero numbers and large headlines.
  static TextStyle display = _display(32.sp, 800, height: 1.1, letterSpacing: -0.6);

  /// Page titles ("Wallet", "Activity").
  static TextStyle pageTitle = _display(28.sp, 750, height: 1.15, letterSpacing: -0.4);

  /// Section headers inside a page.
  static TextStyle sectionTitle = _display(18.sp, 700, letterSpacing: -0.2);

  /// Card titles (business name on a stamp card).
  static TextStyle cardTitle = _display(16.sp, 700, letterSpacing: -0.1);

  static TextStyle body = TextStyle(
    fontFamily: "Inter",
    fontWeight: FontWeight.w400,
    fontSize: AppFontSize.medium,
    color: AppColors.foregroundMuted,
    height: 1.45,
  );

  static TextStyle caption = TextStyle(
    fontFamily: "Inter",
    fontWeight: FontWeight.w400,
    fontSize: AppFontSize.small,
    color: AppColors.foregroundSubtle,
  );

  static TextStyle label = TextStyle(
    fontFamily: "Inter",
    fontWeight: FontWeight.w500,
    fontSize: AppFontSize.medium,
    color: AppColors.foreground,
  );

  static TextStyle button = TextStyle(
    fontFamily: "Inter",
    fontWeight: FontWeight.w600,
    fontSize: AppFontSize.large,
    color: AppColors.white,
  );

  /// Big numbers on KPI tiles and the payment amount field.
  static TextStyle stat = _display(28.sp, 800, height: 1.1, letterSpacing: -0.5);

  /// Small uppercase eyebrow labels ("REWARD", "TODAY").
  static TextStyle eyebrow = TextStyle(
    fontFamily: "Inter",
    fontWeight: FontWeight.w600,
    fontSize: AppFontSize.xSmall,
    letterSpacing: 1.1,
    color: AppColors.foregroundSubtle,
  );

  /// One-time codes (OTP, redemption code) — tabular so digits don't jump.
  static TextStyle code = TextStyle(
    fontFamily: "Inter",
    fontWeight: FontWeight.w700,
    fontSize: 26.sp,
    letterSpacing: 6.sp,
    color: AppColors.foreground,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
