import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/styles/app_icons.dart';

/// Black Apple Pay button per Apple's guidelines. Replace with the gateway
/// SDK's native button (e.g. Stripe's PlatformPayButton) when it is wired.
class ApplePayButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final String label;

  const ApplePayButton({super.key, required this.onPressed, required this.loading, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.applePay,
          // Loading / no amount yet: a lighter tint of the black button.
          disabledBackgroundColor: AppColors.applePay.withValues(alpha: 0.45),
          disabledForegroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
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
                  Icon(AppIcons.apple, color: AppColors.white, size: 24.sp),
                  SizedBox(width: 6.w),
                  Text(label, style: AppTextStyle.button),
                ],
              ),
      ),
    );
  }
}
