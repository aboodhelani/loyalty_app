import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../core/utils/injections.dart';
import '../../../../../shared/presentation/widgets/app_button.dart';
import '../../../../../shared/presentation/widgets/qr_panel.dart';
import '../../../../../shared/presentation/widgets/state_views.dart';
import '../../domain/usecases/wallet_usecases.dart';
import '../bloc/redeem_cubit.dart';
import '../../../../../core/styles/app_icons.dart';

/// Redeem (C11): one-time code + QR for staff, then the success screen.
class RedeemPage extends StatelessWidget {
  final String cardId;

  const RedeemPage({super.key, required this.cardId});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocProvider(
      create: (_) => RedeemCubit(
        cardId: cardId,
        createRedemptionUseCase: sl<CreateRedemptionUseCase>(),
        getCardUseCase: sl<GetStampCardUseCase>(),
      )..start(),
      child: BlocBuilder<RedeemCubit, RedeemState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(s.redeemTitle)),
            body: switch (state) {
              RedeemShowingCode(:final redemption) => ListView(
                  padding: EdgeInsetsDirectional.fromSTEB(20.w, 4.h, 20.w, 24.h),
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(22.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28.sp),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFD9A441), Color(0xFFA9711F)],
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.reward.withValues(alpha: 0.4),
                              blurRadius: 28,
                              offset: const Offset(0, 12)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(AppIcons.gift, color: AppColors.white, size: 30.sp),
                          SizedBox(height: 8.h),
                          if (redemption.businessName != null)
                            Text(
                              redemption.businessName!.toUpperCase(),
                              style: AppTextStyle.eyebrow.copyWith(color: AppColors.white70),
                            ),
                          SizedBox(height: 4.h),
                          Text(
                            redemption.rewardText,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.sectionTitle.copyWith(color: AppColors.white, fontSize: 22.sp),
                          ),
                          SizedBox(height: 20.h),
                          QrPanel(data: redemption.qrPayload, size: 200.sp),
                          SizedBox(height: 16.h),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(redemption.code, style: AppTextStyle.code.copyWith(color: AppColors.white)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(s.redeemInstructions, textAlign: TextAlign.center, style: AppTextStyle.body),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 14.sp, height: 14.sp, child: const CircularProgressIndicator(strokeWidth: 2)),
                        SizedBox(width: 8.w),
                        Text(s.waitingForStaff, style: AppTextStyle.caption),
                      ],
                    ),
                  ],
                ),
              RedeemConfirmed(:final rewardText) => _RedeemSuccess(reward: rewardText),
              RedeemError(:final errorMsg) =>
                ErrorView(message: errorMsg, onRetry: () => context.read<RedeemCubit>().start()),
              _ => const LoadingView(),
            },
          );
        },
      ),
    );
  }
}

class _RedeemSuccess extends StatelessWidget {
  final String reward;

  const _RedeemSuccess({required this.reward});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.all(24.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.3, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              padding: EdgeInsetsDirectional.all(22.sp),
              decoration: const BoxDecoration(color: AppColors.rewardFill, shape: BoxShape.circle),
              child: Icon(AppIcons.confetti, size: 52.sp, color: AppColors.reward),
            ),
          ),
          SizedBox(height: 20.h),
          Text(s.redeemSuccessTitle, style: AppTextStyle.pageTitle),
          SizedBox(height: 8.h),
          Text(s.redeemSuccessMessage(reward), textAlign: TextAlign.center, style: AppTextStyle.body),
          SizedBox(height: 28.h),
          AppButton(label: s.done, onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst)),
        ],
      ),
    );
  }
}
