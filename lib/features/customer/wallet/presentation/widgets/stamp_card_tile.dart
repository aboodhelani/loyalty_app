import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';
import '../../../../../shared/presentation/widgets/pressable.dart';
import '../../../../../core/styles/app_icons.dart';

/// A wallet card (C8) drawn like a physical loyalty card: business, stamp row,
/// X of Y, reward and expiry. Ready cards turn gold.
class StampCardTile extends StatelessWidget {
  final StampCard card;
  final VoidCallback? onTap;

  const StampCardTile({super.key, required this.card, this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final ready = card.isReady;
    final colors = ready
        ? [const Color(0xFFD9A441), const Color(0xFFA9711F)]
        : [const Color(0xFF8A6347), AppColors.primary, const Color(0xFF5A3D2A)];
    final radius = BorderRadius.circular(24.sp);
    final tile = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        boxShadow: [BoxShadow(color: colors.last.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Stack(
            children: [
              // Glossy sheen across the top-left, like a real card.
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.center,
                        colors: [AppColors.white.withValues(alpha: 0.16), AppColors.white.withValues(alpha: 0)],
                      ),
                    ),
                  ),
                ),
              ),
              // Decorative rings for depth
              PositionedDirectional(
                start: -30.w,
                bottom: -60.h,
                child: Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white.withValues(alpha: 0.08), width: 18),
                  ),
                ),
              ),
              PositionedDirectional(
                end: -40.w,
                top: -50.h,
                child: Container(
                  width: 170.w,
                  height: 170.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white.withValues(alpha: 0.06)),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.all(18.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.all(2.sp),
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14.sp)),
                          child: BusinessLogo(
                            logoUrl: card.business.logoUrl,
                            categoryKey: card.business.categoryIcon,
                            size: 40.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.business.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.cardTitle.copyWith(color: AppColors.white),
                              ),
                              if (card.business.categoryName != null)
                                Text(
                                  card.business.categoryName!,
                                  style: AppTextStyle.small.copyWith(color: AppColors.white70),
                                ),
                            ],
                          ),
                        ),
                        if (ready)
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration:
                                BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.sp)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(AppIcons.gift, size: 14.sp, color: AppColors.warningAccent),
                                SizedBox(width: 4.w),
                                Text(
                                  s.readyToRedeem,
                                  style: AppTextStyle.small
                                      .copyWith(color: AppColors.warningAccent, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    _StampRow(filled: card.stampsCount, total: card.stampsRequired),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.reward.toUpperCase(),
                                style: AppTextStyle.xSmall.copyWith(
                                  color: AppColors.white70,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                card.rewardText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.label.copyWith(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${card.stampsCount}/${card.stampsRequired}',
                          style: AppTextStyle.xxLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    if (card.nextStampExpiresAt != null && !ready) ...[
                      SizedBox(height: 6.h),
                      Text(
                        s.expiresOn(Helper.formatDate(card.nextStampExpiresAt!)),
                        style: AppTextStyle.xSmall.copyWith(color: AppColors.white70),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Same tag in the wallet and card details, so the card flies between them.
    return Hero(
      tag: 'stamp-card-${card.id}',
      child: onTap == null ? tile : Pressable(child: tile),
    );
  }
}

/// Compact row of stamp dots that wraps for long programs.
class _StampRow extends StatelessWidget {
  final int filled;
  final int total;

  const _StampRow({required this.filled, required this.total});

  @override
  Widget build(BuildContext context) {
    final size = total > 10 ? 18.sp : 24.sp;
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: List.generate(total, (i) {
        final on = i < filled;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: on ? AppColors.brandCream : AppColors.white.withValues(alpha: 0.12),
            border: Border.all(color: AppColors.white.withValues(alpha: on ? 0 : 0.35), width: 1.2),
          ),
          child: on ? Icon(AppIcons.check, size: size * 0.62, color: AppColors.primary) : null,
        );
      }),
    );
  }
}
