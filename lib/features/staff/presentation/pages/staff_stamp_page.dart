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
import '../../../../shared/presentation/widgets/program_text.dart';
import '../../../../shared/presentation/widgets/scanner_view.dart';
import '../../../../shared/presentation/widgets/stamp_progress.dart';
import '../../../../shared/presentation/widgets/state_views.dart';
import '../../domain/usecases/staff_usecases.dart';
import '../bloc/stamp_scan_cubit.dart';
import '../widgets/result_panel.dart';
import '../../../../core/styles/app_icons.dart';

/// Staff scan (S1).
class StaffStampPage extends StatelessWidget {
  final String businessId;

  const StaffStampPage({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocProvider(
      key: ValueKey(businessId),
      create: (_) => StampScanCubit(
        businessId: businessId,
        scanCustomerUseCase: sl<ScanCustomerUseCase>(),
        addStampUseCase: sl<AddStampUseCase>(),
      ),
      child: BlocConsumer<StampScanCubit, StampScanState>(
        listener: (context, state) {
          if (state is StampScanReady && state.error != null) AppSnackBar.showError(context, state.error!);
        },
        builder: (context, state) {
          final cubit = context.read<StampScanCubit>();
          return Scaffold(
            body: switch (state) {
              StampScanReady(:final session) => ScannerView(
                  key: ValueKey(session),
                  title: s.scanCustomerTitle,
                  hint: s.scanCustomerHint,
                  onValue: cubit.scanned,
                ),
              StampScanFound(:final result, :final stamping) => FoundCard(
                  children: [
                    Text(result.firstName,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.xxxxLarge.copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(height: 4.h),
                    if (result.program != null)
                      Text(programSummary(s, result.program!), textAlign: TextAlign.center, style: AppTextStyle.body),
                    SizedBox(height: 20.h),
                    AppCard(
                      child: Column(
                        children: [
                          Text(
                            result.currentCard == null
                                ? s.newCustomerCard
                                : s.stampsProgress(result.stamps, result.required),
                            style: AppTextStyle.cardTitle,
                          ),
                          SizedBox(height: 14.h),
                          StampGrid(filled: result.stamps, total: result.required, slotSize: 38.sp),
                        ],
                      ),
                    ),
                    if (result.readyCards.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      AppCard(
                        color: AppColors.rewardFill,
                        borderColor: AppColors.reward,
                        child: Row(
                          children: [
                            const Icon(AppIcons.gift, color: AppColors.reward),
                            SizedBox(width: 10.w),
                            Expanded(child: Text(s.customerHasReward(result.firstName), style: AppTextStyle.label)),
                          ],
                        ),
                      ),
                    ],
                    if (!result.canStampToday) ...[
                      SizedBox(height: 12.h),
                      Text(
                        result.blockedReason ?? s.blockedAlreadyToday,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.label.copyWith(color: AppColors.warningAccent),
                      ),
                    ],
                    SizedBox(height: 24.h),
                    AppButton(
                      label: s.addStamp,
                      icon: AppIcons.sealCheck,
                      loading: stamping,
                      onPressed: result.canStampToday ? cubit.addStamp : null,
                    ),
                    SizedBox(height: 8.h),
                    AppButton(label: s.cancel, variant: AppButtonVariant.secondary, onPressed: cubit.reset),
                  ],
                ),
              StampScanDone(:final firstName, :final stamp) => ResultPanel(
                  icon: AppIcons.check,
                  color: AppColors.success,
                  title: s.stampConfirmed(firstName),
                  message: stamp.cardReady
                      ? s.readyToRedeem
                      : s.stampsProgress(stamp.card.stampsCount, stamp.card.stampsRequired),
                  action: AppButton(label: s.scanNext, icon: AppIcons.scan, onPressed: cubit.reset),
                  child: StampGrid(
                    filled: stamp.card.stampsCount,
                    total: stamp.card.stampsRequired,
                    highlightLast: true,
                    slotSize: 38.sp,
                  ),
                ),
              _ => const LoadingView(),
            },
          );
        },
      ),
    );
  }
}
