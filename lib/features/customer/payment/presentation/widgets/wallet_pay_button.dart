import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_icons.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';

/// The platform wallet button: "Pay with Apple Pay" on iOS, "Pay with Google
/// Pay" on Android. Both brands ask for a black button.
class WalletPayButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;

  const WalletPayButton({super.key, required this.onPressed, required this.loading});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final android = Platform.isAndroid;
    return SizedBox(
      height: 54.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.applePay,
          // Loading / no amount yet: a lighter tint of the black button.
          disabledBackgroundColor: AppColors.applePay.withValues(alpha: 0.45),
          disabledForegroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(android ? 27.h : 12.sp)),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? SizedBox(
                width: 22.sp,
                height: 22.sp,
                child: const CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.white),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(android ? AppIcons.google : AppIcons.apple, color: AppColors.white, size: android ? 20.sp : 24.sp),
                  SizedBox(width: 8.w),
                  Text(android ? s.payWithGooglePay : s.payWithApplePay, style: AppTextStyle.button),
                ],
              ),
      ),
    );
  }
}
