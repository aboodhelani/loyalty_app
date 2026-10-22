import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../core/utils/injections.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../../../../shared/domain/models/visit_entry.dart';
import '../../../../../shared/presentation/widgets/app_card.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';
import '../../../../../shared/presentation/widgets/state_views.dart';
import '../../../wallet/domain/usecases/wallet_usecases.dart';
import '../bloc/visit_history_cubit.dart';
import '../../../../../core/styles/app_icons.dart';
import '../../../../../shared/presentation/widgets/animations.dart';

class VisitHistoryPage extends StatelessWidget {
  const VisitHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocProvider(
      create: (_) => VisitHistoryCubit(getVisitHistoryUseCase: sl<GetVisitHistoryUseCase>())..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(s.visitHistory)),
        body: BlocBuilder<VisitHistoryCubit, VisitHistoryState>(
          builder: (context, state) {
            if (state is VisitHistoryError) {
              return ErrorView(message: state.errorMsg, onRetry: () => context.read<VisitHistoryCubit>().load());
            }
            if (state is! VisitHistoryLoaded) return const LoadingView();
            if (state.visits.isEmpty) {
              return EmptyView(icon: AppIcons.history, title: s.visitHistoryEmpty);
            }
            // Group by calendar day, newest first.
            final groups = <String, List<VisitEntry>>{};
            for (final v in state.visits) {
              groups.putIfAbsent(Helper.formatDate(v.date), () => []).add(v);
            }
            return ListView(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 24.h),
              children: [
                for (final (gi, entry) in groups.entries.indexed) ...[
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(6.w, 12.h, 6.w, 8.h),
                    child: Text(entry.key.toUpperCase(), style: AppTextStyle.eyebrow),
                  ),
                  FadeSlideIn(
                      index: gi,
                      child: AppCard(
                        padding: EdgeInsetsDirectional.symmetric(vertical: 4.h),
                        child: Column(
                          children: [
                            for (var i = 0; i < entry.value.length; i++) ...[
                              if (i > 0) Divider(indent: 68.w, endIndent: 16.w),
                              _VisitRow(visit: entry.value[i]),
                            ],
                          ],
                        ),
                      )),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _VisitRow extends StatelessWidget {
  final VisitEntry visit;

  const _VisitRow({required this.visit});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final paid = visit.source == StampSource.payment;
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        children: [
          BusinessLogo(logoUrl: visit.business.logoUrl, categoryKey: visit.business.categoryIcon, size: 40.sp),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(visit.business.name, style: AppTextStyle.label),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      paid ? AppIcons.contactless : AppIcons.scan,
                      size: 13.sp,
                      color: AppColors.foregroundSubtle,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${paid ? s.stampSourcePayment : s.stampSourceStaff} · ${Helper.formatTime(visit.date)}',
                      style: AppTextStyle.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (visit.amount != null)
            Text(
              Helper.formatMoney(visit.amount!, visit.currency ?? 'AED'),
              style: AppTextStyle.label.copyWith(fontWeight: FontWeight.w700),
            ),
        ],
      ),
    );
  }
}
