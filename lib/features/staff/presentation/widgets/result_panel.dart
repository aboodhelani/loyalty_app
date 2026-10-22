import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';

/// Full-screen confirmation used after a stamp or a redemption, readable from
/// across the counter.
class ResultPanel extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? message;
  final Widget? child;
  final Widget action;

  const ResultPanel({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.message,
    this.child,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.all(24.sp),
        child: Column(
          children: [
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.4, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (_, v, c) => Transform.scale(scale: v, child: c),
              child: Container(
                padding: EdgeInsetsDirectional.all(20.sp),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: Icon(icon, size: 52.sp, color: color),
              ),
            ),
            SizedBox(height: 18.h),
            Text(title, textAlign: TextAlign.center, style: AppTextStyle.pageTitle),
            if (message != null) ...[
              SizedBox(height: 8.h),
              Text(message!, textAlign: TextAlign.center, style: AppTextStyle.body),
            ],
            if (child != null) ...[SizedBox(height: 20.h), child!],
            const Spacer(),
            action,
          ],
        ),
      ),
    );
  }
}

/// White sheet over the scanner background for the "found" step.
class FoundCard extends StatelessWidget {
  final List<Widget> children;

  const FoundCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 24.h, 20.w, 24.h),
          children: children,
        ),
      ),
    );
  }
}
