import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_text_style.dart';

/// Large title block for tab root pages: optional eyebrow, title, subtitle and
/// a trailing action. Place it first in the page's scroll view.
class PageHeader extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final String? subtitle;
  final Widget? trailing;

  const PageHeader({super.key, required this.title, this.eyebrow, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, MediaQuery.paddingOf(context).top + 12.h, 20.w, 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null) ...[
                  Text(eyebrow!.toUpperCase(), style: AppTextStyle.eyebrow),
                  SizedBox(height: 4.h),
                ],
                Text(title, style: AppTextStyle.pageTitle),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(subtitle!, style: AppTextStyle.caption),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
