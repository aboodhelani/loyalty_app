import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_colors.dart';
import 'pressable.dart';

/// The base surface of the card-based design: white, rounded, a hairline
/// border and a soft shadow.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  const AppCard({super.key, required this.child, this.padding, this.onTap, this.color, this.borderColor});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22.sp);
    final card = Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: radius,
        border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: [
          BoxShadow(color: AppColors.foreground.withValues(alpha: 0.04), blurRadius: 2, offset: const Offset(0, 1)),
          BoxShadow(color: AppColors.foreground.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding ?? EdgeInsetsDirectional.all(16.sp), child: child),
        ),
      ),
    );
    return onTap == null ? card : Pressable(scale: 0.98, child: card);
  }
}
