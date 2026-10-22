import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_style.dart';
import 'pressable.dart';

enum AppButtonVariant { primary, secondary, danger, ghost }

/// Full-width button with a built-in loading state. While loading or not
/// tappable it shows a lighter tint of its own colour — never grey.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final onBrand = variant == AppButtonVariant.primary || variant == AppButtonVariant.danger;
    final content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: Tween(begin: 0.85, end: 1.0).animate(animation), child: child),
      ),
      child: loading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: 22.sp,
              height: 22.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                strokeCap: StrokeCap.round,
                color: onBrand ? AppColors.white : AppColors.primary,
              ),
            )
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[Icon(icon, size: 20.sp), SizedBox(width: 8.w)],
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            ),
    );

    final Widget button;
    switch (variant) {
      case AppButtonVariant.secondary:
        button = OutlinedButton(onPressed: enabled ? onPressed : null, child: content);
      case AppButtonVariant.ghost:
        button = TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.fromHeight(48.h),
            foregroundColor: AppColors.foregroundMuted,
            textStyle: AppTextStyle.label,
          ),
          onPressed: enabled ? onPressed : null,
          child: content,
        );
      case AppButtonVariant.danger:
        button = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.failedRed,
            disabledBackgroundColor: Color.lerp(AppColors.failedRed, AppColors.white, 0.45),
            disabledForegroundColor: AppColors.white,
          ),
          onPressed: enabled ? onPressed : null,
          child: content,
        );
      case AppButtonVariant.primary:
        button = ElevatedButton(onPressed: enabled ? onPressed : null, child: content);
    }
    return Pressable(enabled: enabled, child: button);
  }
}
