import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_colors.dart';

/// An icon on a tinted rounded square — list rows, tiles and headers.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;

  const IconBadge({super.key, required this.icon, this.color, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final tone = color ?? AppColors.primary;
    return Container(
      width: size.sp,
      height: size.sp,
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size.sp * 0.32),
      ),
      child: Icon(icon, color: tone, size: size.sp * 0.5),
    );
  }
}
