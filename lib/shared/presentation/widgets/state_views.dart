import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_style.dart';
import '../../../core/translations/l10n.dart';
import '../../../core/styles/app_icons.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: SpinKitThreeBounce(color: AppColors.primary, size: 24.sp));
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(24.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.offline, size: 40.sp, color: AppColors.foregroundFaint),
            SizedBox(height: 12.h),
            Text(message, textAlign: TextAlign.center, style: AppTextStyle.body),
            if (onRetry != null) ...[
              SizedBox(height: 12.h),
              TextButton(onPressed: onRetry, child: Text(S.of(context).tryAgain)),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  const EmptyView({super.key, required this.icon, required this.title, this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(32.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(14.sp),
              decoration:
                  BoxDecoration(color: AppColors.surfaceElevated.withValues(alpha: 0.6), shape: BoxShape.circle),
              child: Container(
                padding: EdgeInsetsDirectional.all(22.sp),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Icon(icon, size: 36.sp, color: AppColors.primary),
              ),
            ),
            SizedBox(height: 20.h),
            Text(title, textAlign: TextAlign.center, style: AppTextStyle.sectionTitle),
            if (message != null) ...[
              SizedBox(height: 6.h),
              Text(message!, textAlign: TextAlign.center, style: AppTextStyle.body),
            ],
            if (action != null) ...[SizedBox(height: 24.h), action!],
          ],
        ),
      ),
    );
  }
}
