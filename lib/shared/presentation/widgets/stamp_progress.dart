import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';

class StampProgressBar extends StatelessWidget {
  final double ratio;
  final bool ready;

  const StampProgressBar({super.key, required this.ratio, this.ready = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.sp),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: ratio),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (_, value, __) => LinearProgressIndicator(
          value: value,
          minHeight: 8.h,
          backgroundColor: AppColors.stampEmpty,
          color: ready ? AppColors.reward : AppColors.primary,
        ),
      ),
    );
  }
}

/// The visual stamp grid (C9). [highlightLast] pops the newest stamp in, for
/// the payment-success and staff-confirmation screens.
class StampGrid extends StatelessWidget {
  final int filled;
  final int total;
  final bool highlightLast;
  final double? slotSize;

  const StampGrid({super.key, required this.filled, required this.total, this.highlightLast = false, this.slotSize});

  @override
  Widget build(BuildContext context) {
    final size = slotSize ?? 48.sp;
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      alignment: WrapAlignment.center,
      children: List.generate(total, (i) {
        final isFilled = i < filled;
        final isReward = i == total - 1;
        final slot = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.primary : AppColors.stampEmpty,
            border: isReward && !isFilled ? Border.all(color: AppColors.reward, width: 2) : null,
          ),
          child: Icon(
            isReward ? AppIcons.gift : AppIcons.check,
            size: size * 0.48,
            color: isFilled ? AppColors.white : (isReward ? AppColors.reward : AppColors.neutral100),
          ),
        );
        if (highlightLast && isFilled && i == filled - 1) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.2, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
            child: slot,
          );
        }
        return slot;
      }),
    );
  }
}
