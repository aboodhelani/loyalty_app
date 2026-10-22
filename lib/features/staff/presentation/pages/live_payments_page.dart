import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/helper.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/injections.dart';
import '../../../../shared/presentation/widgets/app_card.dart';
import '../../../../shared/presentation/widgets/page_header.dart';
import '../../../../shared/presentation/widgets/state_views.dart';
import '../../domain/usecases/staff_usecases.dart';
import '../bloc/live_payments_cubit.dart';
import '../../../../core/styles/app_icons.dart';

/// Live payments (S3): amount, customer first name and time, newest first.
class LivePaymentsPage extends StatelessWidget {
  final String businessId;
  final String businessName;

  const LivePaymentsPage({super.key, required this.businessId, required this.businessName});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocProvider(
      key: ValueKey(businessId),
      create: (_) =>
          LivePaymentsCubit(businessId: businessId, getPaymentsUseCase: sl<GetTodaysPaymentsUseCase>())..load(),
      child: Scaffold(
        body: Column(
          children: [
            PageHeader(eyebrow: businessName, title: s.livePaymentsTitle),
            Expanded(child: BlocBuilder<LivePaymentsCubit, LivePaymentsState>(
              builder: (context, state) {
                if (state is LivePaymentsError) {
                  return ErrorView(message: state.errorMsg, onRetry: () => context.read<LivePaymentsCubit>().load());
                }
                if (state is! LivePaymentsLoaded) return const LoadingView();
                if (state.payments.isEmpty) {
                  return EmptyView(
                    icon: AppIcons.contactless,
                    title: s.livePaymentsEmpty,
                    message: s.livePaymentsEmptyMessage,
                  );
                }
                final total = state.payments.fold<double>(0, (sum, p) => sum + p.amount);
                return RefreshIndicator(
                  onRefresh: () => context.read<LivePaymentsCubit>().load(silent: true),
                  child: ListView(
                    padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 24.h),
                    children: [
                      Text(
                        s.todayTotal(state.payments.length, Helper.formatMoney(total, state.payments.first.currency)),
                        style: AppTextStyle.caption,
                      ),
                      SizedBox(height: 10.h),
                      for (final p in state.payments) ...[
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.sp),
                            boxShadow: state.fresh.contains(p.id)
                                ? [BoxShadow(color: AppColors.activeGreen.withValues(alpha: 0.35), blurRadius: 16)]
                                : null,
                          ),
                          child: AppCard(
                            borderColor: state.fresh.contains(p.id) ? AppColors.activeGreen : null,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.all(10.sp),
                                  decoration: const BoxDecoration(color: AppColors.successFill, shape: BoxShape.circle),
                                  child: Icon(AppIcons.contactless, color: AppColors.success, size: 22.sp),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.customerFirstName, style: AppTextStyle.cardTitle),
                                      Text(Helper.formatTime(p.createdAt), style: AppTextStyle.caption),
                                    ],
                                  ),
                                ),
                                Text(
                                  Helper.formatMoney(p.amount, p.currency),
                                  style: AppTextStyle.xLarge.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
