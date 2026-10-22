import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_text_style.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  const StatusPill({super.key, required this.label, required this.background, required this.foreground, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20.sp)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14.sp, color: foreground), SizedBox(width: 4.w)],
          Text(label, style: AppTextStyle.small.copyWith(color: foreground, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
