import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/app_colors.dart';
import '../styles/app_text_style.dart';
import '../styles/app_icons.dart';

/// Shared snack bars: floating, rounded, with an icon, in the brand palette.
class AppSnackBar {
  const AppSnackBar._();

  static SnackBar _build(String message, {required IconData icon, required Color color, String? title}) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      margin: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 16.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
      backgroundColor: AppColors.foreground,
      content: Row(
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(6.sp),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, size: 16.sp, color: AppColors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title, style: AppTextStyle.label.copyWith(color: AppColors.white)),
                Text(
                  message,
                  style: (title == null ? AppTextStyle.medium : AppTextStyle.small)
                      .copyWith(color: title == null ? AppColors.white : AppColors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static SnackBar error(String message) => _build(message, icon: AppIcons.warning, color: AppColors.failedRed);

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(error(message));
  }

  static SnackBar success(String message) => _build(message, icon: AppIcons.check, color: AppColors.success);

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(success(message));
  }

  /// Loyalty notifications from the socket (stamp added, reward ready…).
  static void showNotice(BuildContext context, {required String title, required String body}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_build(body, title: title, icon: AppIcons.ticket, color: AppColors.reward));
  }
}
