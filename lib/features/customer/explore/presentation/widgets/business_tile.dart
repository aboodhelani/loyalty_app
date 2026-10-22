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

/// List view card (C4): a cover photo with the category and distance on it,
/// the logo overlapping its edge, then name, address, the reward and my
/// progress. The map uses the compact [BusinessMapCard].
class BusinessTile extends StatelessWidget {
  final Business business;
  final VoidCallback onTap;

  const BusinessTile({super.key, required this.business, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyle.of(business.category?.slug);
    final image = businessImage(business);
    final address = business.mainBranch?.address ?? '';
    final radius = BorderRadius.circular(24.sp);
    final logoSize = 52.sp;

    return Pressable(
      scale: 0.98,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.10), blurRadius: 24, offset: const Offset(0, 10)),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.sp)),
                      child: SizedBox(
                        height: 132.h,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            BusinessCover(image: image, style: style),
                            // Darkens the top so the chips read on any photo.
                            if (image != null)
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [AppColors.black.withValues(alpha: 0.25), AppColors.transparent],
                                    stops: const [0, 0.55],
                                  ),
                                ),
                              ),
                            PositionedDirectional(
                              start: 12.w,
                              top: 12.h,
                              child: _GlassChip(icon: style.icon, text: business.category?.name ?? ''),
                            ),
                            if (business.distanceKm != null)
                              PositionedDirectional(
                                end: 12.w,
                                top: 12.h,
                                child: _GlassChip(
                                  icon: AppIcons.navigation,
                                  text: Helper.formatDistance(business.distanceKm),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      start: 14.w,
                      bottom: -logoSize / 2,
                      child: Container(
                        padding: EdgeInsetsDirectional.all(3.sp),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(logoSize * 0.34),
                          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: BusinessLogo(
                          logoUrl: business.logoUrl,
                          categoryKey: business.category?.slug,
                          size: logoSize,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(14.w, logoSize / 2 + 10.h, 14.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: AppTextStyle.cardTitle.copyWith(fontSize: 17.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (address.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(AppIcons.mapPin, size: 14.sp, color: AppColors.foregroundSubtle),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                address,
                                style: AppTextStyle.small.copyWith(color: AppColors.foregroundSubtle),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (business.program != null) ...[
                        SizedBox(height: 12.h),
                        BusinessRewardStrip(business: business),
                      ],
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

/// The cover, else the first photo.
String? businessImage(Business business) =>
    business.coverUrl ?? (business.photos.isEmpty ? null : business.photos.first);

/// Cover photo, or the category icon on a soft tint of its colour.
class BusinessCover extends StatelessWidget {
  final String? image;
  final CategoryStyle style;
  final double? iconSize;

  const BusinessCover({super.key, required this.image, required this.style, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final fallback = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [style.color.withValues(alpha: 0.18), AppColors.brandCream],
        ),
      ),
      child: Center(child: Icon(style.icon, color: style.color.withValues(alpha: 0.55), size: iconSize ?? 40.sp)),
    );
    if (image == null || image!.isEmpty) return fallback;
    return CachedNetworkImage(
      imageUrl: image!,
      fit: BoxFit.cover,
      placeholder: (_, __) => fallback,
      errorWidget: (_, __, ___) => fallback,
    );
  }
}

/// Reward line and, when I have a card here, my progress — or the paused
/// notice. Shared by the list and map cards.
class BusinessRewardStrip extends StatelessWidget {
  final Business business;
  final bool dense;

  const BusinessRewardStrip({super.key, required this.business, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final program = business.program!;
    final progress = business.myProgress;
    final ready = progress?.isReady ?? false;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: dense ? 7.h : 10.h),
      decoration: BoxDecoration(
        color: ready ? AppColors.rewardFill : AppColors.brandCream.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(color: ready ? AppColors.warningBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.all(5.sp),
                decoration: BoxDecoration(
                  color: ready ? AppColors.reward : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(AppIcons.gift, size: 12.sp, color: AppColors.white),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  program.isActive ? programSummary(s, program) : s.programPaused,
                  style: AppTextStyle.small.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w600),
                  maxLines: dense ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (progress != null) ...[
            SizedBox(height: dense ? 7.h : 10.h),
            Row(
              children: [
                Expanded(child: _ProgressBar(ratio: progress.ratio, ready: ready)),
                SizedBox(width: 8.w),
                Text(
                  ready ? s.readyToRedeem : '${progress.stampsCount}/${progress.stampsRequired}',
                  style: AppTextStyle.xSmall.copyWith(
                    color: ready ? AppColors.warningAccent : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Small frosted pill over the cover photo.
class _GlassChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _GlassChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.primary),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppTextStyle.xSmall.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w700),
          ),
        ],
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
          minHeight: 6.h,
          backgroundColor: AppColors.white,
          color: ready ? AppColors.reward : AppColors.primary,
        ),
      ),
    );
  }
}
