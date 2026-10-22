import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

/// Light, card-based theme (spec §2 "Design"). Built per brand colour so a
/// rebrand from [AppNotifier] restyles every control.
ThemeData buildAppTheme(Color brand) {
  final radius = BorderRadius.circular(16.sp);
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    splashFactory: InkSparkle.splashFactory,
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.sp)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.foreground,
      titleTextStyle: AppTextStyle.sectionTitle.copyWith(fontSize: 20.sp),
      toolbarHeight: 60.h,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    iconTheme: IconThemeData(color: AppColors.foregroundMuted, size: 24.sp),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
    textTheme: TextTheme(
      headlineLarge: AppTextStyle.xxxxxLarge,
      headlineMedium: AppTextStyle.xLarge,
      titleLarge: AppTextStyle.xxxLarge,
      titleMedium: AppTextStyle.large,
      titleSmall: AppTextStyle.small,
      bodyLarge: AppTextStyle.large,
      bodyMedium: AppTextStyle.medium,
      bodySmall: AppTextStyle.small,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brand,
        foregroundColor: AppColors.white,
        // Loading / not tappable: a lighter tint of the brand, never grey.
        disabledBackgroundColor: Color.lerp(brand, AppColors.white, 0.45),
        disabledForegroundColor: AppColors.white,
        elevation: 0,
        minimumSize: Size.fromHeight(56.h),
        textStyle: AppTextStyle.button,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.foreground,
        disabledForegroundColor: Color.lerp(brand, AppColors.white, 0.45),
        minimumSize: Size.fromHeight(56.h),
        textStyle: AppTextStyle.button.copyWith(color: AppColors.foreground),
        side: const BorderSide(color: AppColors.borderStrong),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: brand,
        textStyle: AppTextStyle.label,
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? brand : AppColors.stroke300,
      ),
      thumbColor: const WidgetStatePropertyAll(AppColors.white),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: brand),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? brand : AppColors.surfaceElevated,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.white : AppColors.foreground,
        ),
        side: const WidgetStatePropertyAll(BorderSide(color: AppColors.border)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => AppTextStyle.small.copyWith(
          color: s.contains(WidgetState.selected) ? brand : AppColors.foregroundSubtle,
          fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceElevated,
      side: const BorderSide(color: AppColors.border),
      labelStyle: AppTextStyle.label,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.light,
      primary: brand,
      secondary: AppColors.primarySoft,
      // Tonal buttons and selected chips use brand cream with brown content.
      secondaryContainer: AppColors.brandCream,
      onSecondaryContainer: brand,
      primaryContainer: AppColors.brandCream,
      onPrimaryContainer: brand,
      surface: AppColors.surfaceElevated,
      error: AppColors.failedRed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceElevated,
      contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 16.h),
      hintStyle: AppTextStyle.medium.copyWith(color: AppColors.foregroundPlaceholder),
      labelStyle: AppTextStyle.medium.copyWith(color: AppColors.foregroundSubtle),
      prefixIconColor: AppColors.foregroundSubtle,
      suffixIconColor: AppColors.foregroundSubtle,
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.7), width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.7), width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: brand, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.failedRed, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.failedRed, width: 1.5.w),
      ),
      errorMaxLines: 2,
    ),
  );
}
