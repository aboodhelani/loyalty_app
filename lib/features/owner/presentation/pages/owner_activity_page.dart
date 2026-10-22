import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/helper.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/injections.dart';
import '../../../../shared/domain/models/activity_summary.dart';
import '../../../../shared/domain/models/transaction.dart';
import '../../../../shared/presentation/widgets/app_card.dart';
import '../../../../shared/presentation/widgets/page_header.dart';
import '../../../../shared/presentation/widgets/section_header.dart';
import '../../../../shared/presentation/widgets/state_views.dart';
import '../../../../shared/presentation/widgets/status_pill.dart';
import '../../domain/usecases/owner_usecases.dart';
import '../bloc/owner_activity_cubit.dart';
import '../widgets/stat_tile.dart';
import '../../../../core/styles/app_icons.dart';
import '../../../../shared/presentation/widgets/animations.dart';

/// Activity (B4).
class OwnerActivityPage extends StatelessWidget {
  final String businessId;
  final String businessName;

  const OwnerActivityPage({super.key, required this.businessId, required this.businessName});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocProvider(
      key: ValueKey(businessId),
      create: (_) => OwnerActivityCubit(businessId: businessId, getActivityUseCase: sl<GetActivityUseCase>())
        ..load(ActivityRange.today),
      child: Scaffold(
        body: BlocBuilder<OwnerActivityCubit, OwnerActivityState>(
          builder: (context, state) {
            final cubit = context.read<OwnerActivityCubit>();
            return RefreshIndicator(
              onRefresh: () => cubit.load(state.range, silent: true),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  PageHeader(eyebrow: businessName, title: s.ownerActivityTab),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedButton<ActivityRange>(
                          segments: [
                            ButtonSegment(value: ActivityRange.today, label: Text(s.rangeToday)),
                            ButtonSegment(value: ActivityRange.week, label: Text(s.range7d)),
                            ButtonSegment(value: ActivityRange.month, label: Text(s.range30d)),
                          ],
                          selected: {state.range},
                          showSelectedIcon: false,
                          onSelectionChanged: (v) => cubit.load(v.first),
                        ),
                        SizedBox(height: 16.h),
                        switch (state) {
                          OwnerActivityLoaded(:final summary) => _Summary(summary: summary),
                          OwnerActivityError(:final errorMsg) =>
                            ErrorView(message: errorMsg, onRetry: () => cubit.load(state.range)),
                          _ => SizedBox(height: 200.h, child: const LoadingView()),
                        },
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final ActivitySummary summary;

  const _Summary({required this.summary});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final tiles = [
      StatTile(icon: AppIcons.contactless, label: s.kpiPayments, value: '${summary.payments}'),
      StatTile(icon: AppIcons.sealCheck, label: s.kpiStamps, value: '${summary.stampsIssued}'),
      StatTile(icon: AppIcons.gift, label: s.kpiRewards, value: '${summary.rewardsRedeemed}'),
      StatTile(
        icon: AppIcons.users,
        label: s.kpiNewCustomers,
        value: '${summary.newCustomers}',
        caption: '${s.kpiReturning}: ${summary.returningCustomers}',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsetsDirectional.all(20.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.sp),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF8A6347), AppColors.primary, const Color(0xFF4E3424)],
            ),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.kpiRevenue.toUpperCase(), style: AppTextStyle.eyebrow.copyWith(color: AppColors.white70)),
              SizedBox(height: 6.h),
              CountUp(
                value: summary.revenue,
                format: (v) => Helper.formatMoney(v.toDouble().roundToDouble(), summary.currency),
                style: AppTextStyle.display.copyWith(color: AppColors.white),
              ),
              SizedBox(height: 4.h),
              Text('${summary.payments} ${s.kpiPayments.toLowerCase()}',
                  style: AppTextStyle.small.copyWith(color: AppColors.white70)),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          // No AppBar above, so drop the inherited status-bar inset.
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 1.6,
          children: [for (var i = 0; i < tiles.length; i++) FadeSlideIn(index: i, child: tiles[i])],
        ),
        SectionHeader(title: s.recentTransactions),
        if (summary.recentTransactions.isEmpty)
          Text(s.noTransactions, style: AppTextStyle.caption)
        else
          AppCard(
            padding: EdgeInsetsDirectional.zero,
            child: Column(
              children: [
                for (var i = 0; i < summary.recentTransactions.length; i++) ...[
                  if (i > 0) const Divider(),
                  _TransactionRow(tx: summary.recentTransactions[i]),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final PaymentTransaction tx;

  const _TransactionRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final (label, bg, fg) = switch (tx.status) {
      TransactionStatus.succeeded => (s.statusSucceeded, AppColors.successFill, AppColors.success),
      TransactionStatus.pending => (s.statusPending, AppColors.warningFill, AppColors.warningText),
      TransactionStatus.failed => (s.statusFailed, AppColors.dangerFill, AppColors.dangerText),
      TransactionStatus.refunded => (s.statusRefunded, AppColors.infoFill, AppColors.infoText),
    };
    return ListTile(
      title: Text(tx.customerFirstName, style: AppTextStyle.label),
      subtitle: Text(Helper.formatDateTime(tx.createdAt), style: AppTextStyle.caption),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(Helper.formatMoney(tx.amount, tx.currency), style: AppTextStyle.label),
          SizedBox(height: 4.h),
          StatusPill(label: label, background: bg, foreground: fg),
        ],
      ),
    );
  }
}
