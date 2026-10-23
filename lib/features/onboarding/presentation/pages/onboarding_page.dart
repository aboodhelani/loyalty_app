import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_icons.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/constant/app_constants.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/location_service.dart';
import '../../../../shared/data/data_sources/app_shared_prefs.dart';
import '../../../../shared/presentation/widgets/app_button.dart';
import '../../../auth/presentation/widgets/auth_hero.dart';

/// Onboarding (C1): three slides, location permission, and "Continue" without
/// signing up. Same visual language as sign-in: brand gradient on top, cream
/// sheet below.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  static const _count = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    sl<AppSharedPrefs>().setOnboardingSeen();
    Navigator.of(context).pushReplacementNamed(AppRouteEnum.main.name);
  }

  Future<void> _allowLocation() async {
    await sl<LocationService>().requestPermission();
    _finish();
  }

  void _next() => _controller.nextPage(duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final slides = [
      (s.onboardingTitle1, s.onboardingBody1),
      (s.onboardingTitle2, s.onboardingBody2),
      (s.onboardingTitle3, s.onboardingBody3),
    ];
    final last = _page == _count - 1;
    final top = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF8A6347), AppColors.primary, const Color(0xFF4E3424)],
            ),
          ),
          child: Stack(
            children: [
              PositionedDirectional(end: -70.w, top: -40.h, child: Glow(size: 260.w)),
              PositionedDirectional(start: -60.w, top: 260.h, child: Glow(size: 200.w)),
              Column(
                children: [
                  // Top bar: wordmark + Skip
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20.w, top + 12.h, 12.w, 0),
                    child: Row(
                      children: [
                        Icon(AppIcons.ticket, color: AppColors.brandCream, size: 22.sp),
                        SizedBox(width: 8.w),
                        Text(appName, style: AppTextStyle.cardTitle.copyWith(color: AppColors.brandCream)),
                        const Spacer(),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: last ? 0 : 1,
                          child: TextButton(
                            onPressed: last ? null : _finish,
                            style: TextButton.styleFrom(foregroundColor: AppColors.white),
                            child: Text(s.skip),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Illustrations — swipeable
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (i) => setState(() => _page = i),
                      children: const [
                        _SlideArt(child: _CardsArt()),
                        _SlideArt(child: _PayArt()),
                        _SlideArt(child: _MapArt()),
                      ],
                    ),
                  ),
                  // Cream sheet with text and actions
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(24.w, 28.h, 24.w, MediaQuery.paddingOf(context).bottom + 20.h),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32.sp)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            for (var i = 0; i < _count; i++) ...[
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: i == _page ? 24.w : 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: i <= _page ? AppColors.primary : AppColors.borderStrong,
                                  borderRadius: BorderRadius.circular(8.sp),
                                ),
                              ),
                              SizedBox(width: 6.w),
                            ],
                            const Spacer(),
                            Text(s.stepOf(_page + 1, _count), style: AppTextStyle.caption),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          height: 150.h,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 280),
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation),
                                child: child,
                              ),
                            ),
                            child: Column(
                              key: ValueKey(_page),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(slides[_page].$1, style: AppTextStyle.pageTitle.copyWith(fontSize: 26.sp)),
                                SizedBox(height: 10.h),
                                Text(slides[_page].$2, style: AppTextStyle.body),
                              ],
                            ),
                          ),
                        ),
                        if (last) ...[
                          AppButton(label: s.allowLocation, icon: AppIcons.crosshair, onPressed: _allowLocation),
                          SizedBox(height: 8.h),
                          AppButton(label: s.continueLabel, variant: AppButtonVariant.ghost, onPressed: _finish),
                        ] else ...[
                          AppButton(label: s.next, onPressed: _next),
                          SizedBox(height: 56.h),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Centres a slide's art with a gentle float-in.
class _SlideArt extends StatelessWidget {
  final Widget child;

  const _SlideArt({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (_, v, c) => Transform.scale(scale: v, child: c),
        child: SizedBox(width: 280.w, height: 280.w, child: child),
      ),
    );
  }
}

/// Slide 1 — every card in one wallet.
class _CardsArt extends StatelessWidget {
  const _CardsArt();

  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsetsDirectional.all(20.w), child: const LoyaltyCardFan());
}

/// Slide 2 — pay in the app, the stamp lands automatically.
class _PayArt extends StatelessWidget {
  const _PayArt();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        _Rings(size: 260.w),
        Container(
          width: 128.w,
          height: 128.w,
          decoration: BoxDecoration(
            color: AppColors.brandCream,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Icon(AppIcons.contactless, size: 64.sp, color: AppColors.primary),
        ),
        PositionedDirectional(
          top: 40.h,
          end: 20.w,
          child: _Chip(icon: AppIcons.sealCheck, label: s.onboardingStampChip, color: AppColors.success),
        ),
        PositionedDirectional(
          bottom: 44.h,
          start: 12.w,
          child: _Chip(icon: Platform.isAndroid ? AppIcons.google : AppIcons.apple, label: 'Pay', color: AppColors.applePay),
        ),
      ],
    );
  }
}

/// Slide 3 — rewards on the map near you.
class _MapArt extends StatelessWidget {
  const _MapArt();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    Widget pin(IconData icon, Color color, double size) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 3),
            boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Icon(icon, color: AppColors.white, size: size * 0.48),
        );
    return Stack(
      alignment: Alignment.center,
      children: [
        _Rings(size: 260.w),
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: AppColors.brandCream,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Icon(AppIcons.mapPinFill, size: 58.sp, color: AppColors.primary),
        ),
        PositionedDirectional(top: 26.h, start: 40.w, child: pin(AppIcons.cafe, AppColors.categoryCafe, 46.w)),
        PositionedDirectional(top: 70.h, end: 18.w, child: pin(AppIcons.barber, AppColors.categoryBarber, 40.w)),
        PositionedDirectional(bottom: 40.h, end: 50.w, child: pin(AppIcons.restaurant, AppColors.categoryRestaurant, 44.w)),
        PositionedDirectional(
          bottom: 30.h,
          start: 8.w,
          child: _Chip(icon: AppIcons.crosshair, label: s.onboardingNearby, color: AppColors.infoText),
        ),
      ],
    );
  }
}

class _Rings extends StatelessWidget {
  final double size;

  const _Rings({required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (final f in [1.0, 0.75])
          Container(
            width: size * f,
            height: size * f,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white.withValues(alpha: 0.12), width: 1.5),
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.sp),
        boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          Text(label, style: AppTextStyle.small.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
