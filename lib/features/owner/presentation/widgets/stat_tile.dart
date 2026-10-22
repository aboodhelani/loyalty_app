import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../shared/presentation/widgets/app_card.dart';
import '../../../../shared/presentation/widgets/icon_badge.dart';
import '../../../../shared/presentation/widgets/animations.dart';

class StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? caption;

  const StatTile({super.key, required this.icon, required this.label, required this.value, this.caption});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsetsDirectional.all(14.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconBadge(icon: icon, size: 34),
              const Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: int.tryParse(value) != null
                    ? CountUp(value: int.parse(value), style: AppTextStyle.stat.copyWith(fontSize: 26.sp))
                    : Text(value, style: AppTextStyle.stat.copyWith(fontSize: 26.sp)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyle.label, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (caption != null) Text(caption!, style: AppTextStyle.caption, maxLines: 1),
            ],
          ),
        ],
      ),
    );
  }
}
