import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/styles/app_icons.dart';

/// Brand header of the sign-in flow: close/back, wordmark, headline and a
/// small fan of loyalty cards. Collapses to the top bar while typing or after
/// the first step, so the form keeps the room it needs.
class AuthHero extends StatelessWidget {
  final bool compact;
  final bool showBackArrow;
  final VoidCallback onBack;

  const AuthHero({super.key, required this.compact, required this.showBackArrow, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final top = MediaQuery.paddingOf(context).top;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      height: top + (compact ? 76.h : 300.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF8A6347), AppColors.primary, const Color(0xFF4E3424)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Soft decorative circles
          PositionedDirectional(
            end: -60.w,
            top: -40.h,
            child: Glow(size: 220.w),
          ),
          PositionedDirectional(
            start: -50.w,
            bottom: -70.h,
            child: Glow(size: 180.w),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, top + 8.h, 16.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _RoundButton(icon: showBackArrow ? AppIcons.back : AppIcons.close, onTap: onBack),
                    const Spacer(),
                    Icon(AppIcons.ticket, color: AppColors.brandCream, size: 20.sp),
                    SizedBox(width: 6.w),
                    Text(appName, style: AppTextStyle.cardTitle.copyWith(color: AppColors.brandCream)),
                    const Spacer(),
                    SizedBox(width: 40.sp),
                  ],
                ),
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: compact ? 0 : 1,
                    child: compact
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.w, 20.h, 8.w, 40.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        s.authWelcome.toUpperCase(),
                                        style: AppTextStyle.eyebrow.copyWith(color: AppColors.brandCream),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        s.authHeroTitle,
                                        style: AppTextStyle.pageTitle.copyWith(color: AppColors.white, fontSize: 26.sp),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        s.authHeroSubtitle,
                                        style: AppTextStyle.small.copyWith(color: AppColors.white70, height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                const Expanded(flex: 4, child: LoyaltyCardFan()),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 40.sp, height: 40.sp, child: Icon(icon, color: AppColors.white, size: 20.sp)),
      ),
    );
  }
}

class Glow extends StatelessWidget {
  final double size;

  const Glow({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white.withValues(alpha: 0.06)),
    );
  }
}

/// Three tilted mini loyalty cards — the product in one glance. Shared by
/// sign-in and onboarding.
class LoyaltyCardFan extends StatelessWidget {
  const LoyaltyCardFan({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.9,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth * 0.82;
          final h = w * 0.62;
          Widget card(double angle, Offset offset, List<Color> colors, int filled) => Transform.translate(
                offset: offset,
                child: Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: w,
                    height: h,
                    padding: EdgeInsetsDirectional.all(w * 0.08),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w * 0.1),
                      gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.25), blurRadius: 14, offset: const Offset(0, 6))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: w * 0.3,
                          height: h * 0.1,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < 5; i++) ...[
                              Container(
                                width: w * 0.11,
                                height: w * 0.11,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i < filled ? AppColors.brandCream : AppColors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              if (i < 4) SizedBox(width: w * 0.04),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
          return Stack(
            alignment: Alignment.center,
            children: [
              card(-0.22, Offset(-w * 0.12, -h * 0.35), [const Color(0xFF6E8F4E), const Color(0xFF4F6B37)], 2),
              card(0.12, Offset(w * 0.1, -h * 0.05), [const Color(0xFFD9A441), const Color(0xFFA9711F)], 5),
              card(-0.05, Offset(-w * 0.02, h * 0.4), [AppColors.brandCream, const Color(0xFFE3D6B0)], 0),
            ],
          );
        },
      ),
    );
  }
}
