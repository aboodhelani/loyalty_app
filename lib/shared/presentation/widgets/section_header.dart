import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_text_style.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 20.h, bottom: 10.h),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyle.sectionTitle)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
