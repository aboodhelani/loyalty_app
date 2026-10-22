import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../../../core/utils/injections.dart';
import '../../../../shared/presentation/widgets/app_button.dart';
import '../../../../shared/presentation/widgets/app_card.dart';
import '../../../../shared/presentation/widgets/scanner_view.dart';
import '../../../../shared/presentation/widgets/state_views.dart';
import '../../domain/usecases/staff_usecases.dart';
import '../bloc/redeem_scan_cubit.dart';
import '../widgets/result_panel.dart';
import '../../../../core/styles/app_icons.dart';

/// Staff redeem (S2).
class StaffRedeemPage extends StatelessWidget {
  final String businessId;

  const StaffRedeemPage({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocProvider(
      key: ValueKey(businessId),
      create: (_) => RedeemScanCubit(
        businessId: businessId,
        resolveUseCase: sl<ResolveRedemptionUseCase>(),
        confirmUseCase: sl<ConfirmRedemptionUseCase>(),
      ),
      child: BlocConsumer<RedeemScanCubit, RedeemScanState>(
        listener: (context, state) {
          if (state is RedeemScanReady && state.error != null) AppSnackBar.showError(context, state.error!);
        },
        builder: (context, state) {
          final cubit = context.read<RedeemScanCubit>();
          return Scaffold(
            body: switch (state) {
              RedeemScanReady(:final session) => ScannerView(
                  key: ValueKey(session),
                  title: s.scanRedemptionTitle,
                  hint: s.scanRedemptionHint,
                  onValue: cubit.scanned,
                ),
              RedeemScanFound(:final redemption, :final confirming) => FoundCard(
                  children: [
                    if (redemption.customerFirstName != null)
                      Text(
                        redemption.customerFirstName!,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.xxxxLarge.copyWith(fontWeight: FontWeight.w700),
                      ),
                    SizedBox(height: 20.h),
                    AppCard(
                      color: AppColors.rewardFill,
                      borderColor: AppColors.reward,
                      child: Column(
                        children: [
                          Icon(AppIcons.gift, color: AppColors.reward, size: 36.sp),
                          SizedBox(height: 8.h),
                          Text(s.rewardToGive, style: AppTextStyle.caption),
                          SizedBox(height: 4.h),
                          Text(redemption.rewardText,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.xxLarge.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    AppButton(
                      label: s.confirmRedeemed,
                      icon: AppIcons.sealCheck,
                      loading: confirming,
                      onPressed: cubit.confirm,
                    ),
                    SizedBox(height: 8.h),
                    AppButton(label: s.cancel, variant: AppButtonVariant.secondary, onPressed: cubit.reset),
                  ],
                ),
              RedeemScanDone(:final redemption) => ResultPanel(
                  icon: AppIcons.confetti,
                  color: AppColors.reward,
                  title: redemption.rewardText,
                  message: s.rewardConfirmed,
                  action: AppButton(label: s.scanNext, icon: AppIcons.scan, onPressed: cubit.reset),
                ),
              _ => const LoadingView(),
            },
          );
        },
      ),
    );
  }
}
