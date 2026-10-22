import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/utils/injections.dart';
import '../../../../shared/data/data_sources/app_shared_prefs.dart';
import '../../../../shared/presentation/session/session_cubit.dart';
import '../../../../core/styles/app_icons.dart';

/// Restores the session, then goes to onboarding (first launch) or the app.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await context.read<SessionCubit>().restore();
    if (!mounted) return;
    final route = sl<AppSharedPrefs>().getOnboardingSeen() ? AppRouteEnum.main : AppRouteEnum.onboarding;
    Navigator.of(context).pushReplacementNamed(route.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(20.sp),
              decoration: BoxDecoration(color: AppColors.brandCream, borderRadius: BorderRadius.circular(28.sp)),
              child: Icon(AppIcons.ticket, size: 56.sp, color: AppColors.primary),
            ),
            SizedBox(height: 18.h),
            Text('Loyalty', style: AppTextStyle.pageTitle.copyWith(color: AppColors.brandCream)),
            SizedBox(height: 28.h),
            SpinKitThreeBounce(color: AppColors.brandCream, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
