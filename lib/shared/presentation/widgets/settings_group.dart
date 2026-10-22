import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_style.dart';
import 'app_card.dart';
import 'icon_badge.dart';
import '../../../core/styles/app_icons.dart';

/// Grouped list of rows inside one card, iOS-settings style.
class SettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SettingsGroup({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 6.w, bottom: 8.h, top: 8.h),
            child: Text(title!.toUpperCase(), style: AppTextStyle.eyebrow),
          ),
        AppCard(
          padding: EdgeInsetsDirectional.symmetric(vertical: 4.h),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) Divider(indent: 68.w, endIndent: 16.w, color: AppColors.border.withValues(alpha: 0.6)),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const SettingsTile({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22.sp),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          children: [
            IconBadge(icon: icon, color: iconColor, size: 40),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.label.copyWith(color: titleColor)),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(subtitle!, style: AppTextStyle.caption),
                  ],
                ],
              ),
            ),
            trailing ??
                (onTap == null
                    ? const SizedBox.shrink()
                    : Icon(AppIcons.chevron, color: AppColors.foregroundFaint, size: 22.sp)),
          ],
        ),
      ),
    );
  }
}
