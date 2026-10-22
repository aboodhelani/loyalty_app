import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/injections.dart';
import '../../../../../shared/presentation/session/session_cubit.dart';
import '../../../../../shared/presentation/widgets/page_header.dart';
import '../../../../../shared/presentation/widgets/state_views.dart';
import '../../domain/usecases/wallet_usecases.dart';
import '../bloc/my_qr_cubit.dart';
import '../widgets/sign_in_prompt.dart';
import '../../../../../core/styles/app_icons.dart';

/// Scan tab — My QR (C10): a pass-style card with the rotating, server-signed
/// QR and a countdown ring.
class MyQrPage extends StatelessWidget {
  const MyQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final user = context.select((SessionCubit c) => c.state.user);
    return Scaffold(
      body: Column(
        children: [
          PageHeader(eyebrow: s.showAtCounter, title: s.myQrTitle),
          Expanded(
            child: user == null
                ? SignInPrompt(icon: AppIcons.qrCode, title: s.signInForQr, message: s.signInForQrMessage)
                : BlocProvider(
                    // Keyed by user so a different sign-in never shows the old QR.
                    key: ValueKey(user.id),
                    create: (_) => MyQrCubit(getQrTokenUseCase: sl<GetQrTokenUseCase>())..start(),
                    child: BlocBuilder<MyQrCubit, MyQrState>(
                      builder: (context, state) {
                        final token = state.token;
                        if (token == null) {
                          return state.error != null
                              ? ErrorView(message: state.error!, onRetry: () => context.read<MyQrCubit>().start())
                              : const LoadingView();
                        }
                        final total = qrRefreshInterval.inSeconds;
                        return ListView(
                          padding: EdgeInsetsDirectional.fromSTEB(20.w, 4.h, 20.w, 24.h),
                          children: [
                            _PassCard(
                              name: user.name,
                              token: token.token,
                              secondsLeft: state.secondsLeft,
                              total: total,
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(AppIcons.lock, size: 16.sp, color: AppColors.foregroundSubtle),
                                SizedBox(width: 6.w),
                                Text(s.secured, style: AppTextStyle.caption),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(s.myQrInstructions, textAlign: TextAlign.center, style: AppTextStyle.body),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PassCard extends StatelessWidget {
  final String name;
  final String token;
  final int secondsLeft;
  final int total;

  const _PassCard({required this.name, required this.token, required this.secondsLeft, required this.total});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.sp),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF8A6347), AppColors.primary, const Color(0xFF4E3424)],
        ),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 28, offset: const Offset(0, 12))
        ],
      ),
      padding: EdgeInsetsDirectional.all(22.sp),
      child: Column(
        children: [
          Row(
            children: [
              Icon(AppIcons.ticket, color: AppColors.brandCream, size: 22.sp),
              SizedBox(width: 8.w),
              Text(appName, style: AppTextStyle.cardTitle.copyWith(color: AppColors.brandCream)),
              const Spacer(),
              _CountdownRing(secondsLeft: secondsLeft, total: total),
            ],
          ),
          SizedBox(height: 22.h),
          Container(
            padding: EdgeInsetsDirectional.all(16.sp),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(22.sp)),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: QrImageView(
                key: ValueKey(token),
                data: token,
                size: 220.sp,
                eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle, color: AppColors.primary),
                dataModuleStyle:
                    QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.foreground),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(s.scanToCollect.toUpperCase(), style: AppTextStyle.eyebrow.copyWith(color: AppColors.white70)),
          SizedBox(height: 4.h),
          Text(name, style: AppTextStyle.sectionTitle.copyWith(color: AppColors.white, fontSize: 22.sp)),
        ],
      ),
    );
  }
}

class _CountdownRing extends StatelessWidget {
  final int secondsLeft;
  final int total;

  const _CountdownRing({required this.secondsLeft, required this.total});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38.sp,
      height: 38.sp,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: (secondsLeft / total).clamp(0, 1),
            strokeWidth: 3,
            color: AppColors.brandCream,
            backgroundColor: AppColors.white.withValues(alpha: 0.15),
          ),
          Text('$secondsLeft', style: AppTextStyle.small.copyWith(color: AppColors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
