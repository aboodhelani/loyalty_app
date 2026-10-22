import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_icons.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';
import '../../../../../shared/presentation/widgets/pressable.dart';
import 'business_tile.dart';

/// Map preview card (C3) for the selected pin: a compact row — photo, name,
/// category · distance, an open arrow — with the reward strip below. Kept
/// short so most of the map stays visible.
class BusinessMapCard extends StatelessWidget {
  final Business business;
  final VoidCallback onTap;

  const BusinessMapCard({super.key, required this.business, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyle.of(business.category?.slug);
    final radius = BorderRadius.circular(22.sp);
    final meta = [
      if (business.category?.name.isNotEmpty ?? false) business.category!.name,
      if (business.distanceKm != null) Helper.formatDistance(business.distanceKm),
    ].join('  ·  ');

    return Pressable(
      scale: 0.98,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(color: AppColors.black.withValues(alpha: 0.16), blurRadius: 28, offset: const Offset(0, 12)),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Padding(
              padding: EdgeInsetsDirectional.all(10.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.sp),
                        child: SizedBox(
                          width: 64.sp,
                          height: 64.sp,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              BusinessCover(image: businessImage(business), style: style, iconSize: 26.sp),
                              if (business.logoUrl != null && businessImage(business) != null)
                                PositionedDirectional(
                                  start: 4.sp,
                                  bottom: 4.sp,
                                  child: Container(
                                    padding: EdgeInsetsDirectional.all(1.5.sp),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(8.sp),
                                    ),
                                    child: BusinessLogo(
                                      logoUrl: business.logoUrl,
                                      categoryKey: business.category?.slug,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              business.name,
                              style: AppTextStyle.cardTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(style.icon, size: 13.sp, color: AppColors.primary),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    meta,
                                    style: AppTextStyle.small.copyWith(color: AppColors.foregroundSubtle),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 36.sp,
                        height: 36.sp,
                        decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Icon(AppIcons.chevron, size: 18.sp, color: AppColors.white),
                      ),
                    ],
                  ),
                  if (business.program != null) ...[
                    SizedBox(height: 10.h),
                    BusinessRewardStrip(business: business, dense: true),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
