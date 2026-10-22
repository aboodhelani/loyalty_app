import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_icons.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';
import '../../../../../shared/presentation/widgets/pressable.dart';
import '../../../../../shared/presentation/widgets/program_text.dart';

/// A business row: list view (C4) and the map preview card (C3) — photo,
/// name, category, distance, reward and my progress. A warm light surface with
/// brown accents (reward chip, distance, progress).
class BusinessTile extends StatelessWidget {
  final Business business;
  final VoidCallback onTap;

  const BusinessTile({super.key, required this.business, required this.onTap});

  /// Warm white-to-cream surface; brown is kept for accents only.
  static const _gradient = [Color(0xFFFFFFFF), Color(0xFFFBF6E9)];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final program = business.program;
    final progress = business.myProgress;
    final ready = progress?.isReady ?? false;
    final style = CategoryStyle.of(business.category?.slug);
    final image = business.coverUrl ?? (business.photos.isEmpty ? null : business.photos.first);
    final radius = BorderRadius.circular(24.sp);

    return Pressable(
      scale: 0.98,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: _gradient),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.12), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Stack(
              children: [
                // Soft sheen and a decorative ring, as on the wallet cards.
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                          colors: [AppColors.white.withValues(alpha: 0.6), AppColors.white.withValues(alpha: 0)],
                        ),
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  end: -36.w,
                  bottom: -50.h,
                  child: Container(
                    width: 130.w,
                    height: 130.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.05), width: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.all(10.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Photo(image: image, style: style),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      business.name,
                                      style: AppTextStyle.cardTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (business.distanceKm != null) ...[
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.brandCream,
                                        borderRadius: BorderRadius.circular(20.sp),
                                      ),
                                      child: Text(
                                        Helper.formatDistance(business.distanceKm),
                                        style: AppTextStyle.xSmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                business.category?.name ?? '',
                                style: AppTextStyle.small.copyWith(color: AppColors.foregroundSubtle),
                              ),
                              if (program != null) ...[
                                SizedBox(height: 10.h),
                                Container(
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12.sp),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(AppIcons.gift, size: 14.sp, color: AppColors.reward),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          program.isActive ? programSummary(s, program) : s.programPaused,
                                          style: AppTextStyle.small.copyWith(
                                            color: AppColors.brandCream,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (progress != null) ...[
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Expanded(child: _ProgressBar(ratio: progress.ratio, ready: ready)),
                                    SizedBox(width: 8.w),
                                    Text(
                                      ready ? s.readyToRedeem : '${progress.stampsCount}/${progress.stampsRequired}',
                                      style: AppTextStyle.small.copyWith(
                                        color: ready ? AppColors.warningAccent : AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  final String? image;
  final CategoryStyle style;

  const _Photo({required this.image, required this.style});

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: AppColors.brandCream,
      child: Center(child: Icon(style.icon, color: AppColors.primary, size: 28.sp)),
    );
    return Container(
      width: 92.w,
      height: 104.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.sp),
        border: Border.all(color: AppColors.brandCream, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.5.sp),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image == null
                ? fallback
                : CachedNetworkImage(
                    imageUrl: image!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => fallback,
                    errorWidget: (_, __, ___) => fallback,
                  ),
            PositionedDirectional(
              start: 6.w,
              top: 6.h,
              child: Container(
                padding: EdgeInsetsDirectional.all(5.sp),
                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                child: Icon(style.icon, size: 14.sp, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Brown progress on a cream track; gold when the reward is ready.
class _ProgressBar extends StatelessWidget {
  final double ratio;
  final bool ready;

  const _ProgressBar({required this.ratio, required this.ready});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.sp),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: ratio),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (_, v, __) => LinearProgressIndicator(
          value: v,
          minHeight: 7.h,
          backgroundColor: AppColors.brandCream,
          color: ready ? AppColors.reward : AppColors.primary,
        ),
      ),
    );
  }
}
