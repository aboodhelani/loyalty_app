import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/router/app_route_enum.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../shared/domain/models/transaction.dart';
import '../../../../../shared/presentation/widgets/app_button.dart';
import '../../../../../shared/presentation/widgets/app_card.dart';
import '../../../../../shared/presentation/widgets/program_text.dart';
import '../../../../../shared/presentation/widgets/stamp_progress.dart';
import '../../../../../core/styles/app_icons.dart';

/// Payment success (C7): receipt plus the animated "Stamp added: 3 of 5".
class PaymentSuccessPage extends StatelessWidget {
  final PaymentTransaction transaction;

  const PaymentSuccessPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final tx = transaction;
    final card = tx.card;
    final stamped = tx.stampOutcome == StampOutcome.awarded;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 24.h),
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.4, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  padding: EdgeInsetsDirectional.all(16.sp),
                  decoration: const BoxDecoration(color: AppColors.successFill, shape: BoxShape.circle),
                  child: Icon(AppIcons.check, size: 44.sp, color: AppColors.success),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(s.paymentSuccessTitle, textAlign: TextAlign.center, style: AppTextStyle.pageTitle),
            SizedBox(height: 4.h),
            Text(
              Helper.formatMoney(tx.amount, tx.currency),
              textAlign: TextAlign.center,
              style: AppTextStyle.stat,
            ),
            SizedBox(height: 22.h),
            if (tx.stampOutcomeRaw != null)
              AppCard(
                child: Column(
                  children: [
                    if (stamped && card != null) ...[
                      Text(
                        s.stampAdded(card.stampsCount, card.stampsRequired),
                        style: AppTextStyle.xLarge.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 14.h),
                      StampGrid(filled: card.stampsCount, total: card.stampsRequired, highlightLast: true),
                      if (card.isReady) ...[
                        SizedBox(height: 12.h),
                        Text(
                          s.cardNowReady,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.label.copyWith(color: AppColors.warningAccent),
                        ),
                      ],
                    ] else ...[
                      Icon(AppIcons.info, color: AppColors.warningAccent, size: 28.sp),
                      SizedBox(height: 8.h),
                      Text(
                        tx.stampMessage ?? stampOutcomeMessage(s, tx.stampOutcome),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.body,
                      ),
                      if (card != null) ...[
                        SizedBox(height: 12.h),
                        StampGrid(filled: card.stampsCount, total: card.stampsRequired, slotSize: 36.sp),
                      ],
                    ],
                  ],
                ),
              ),
            SizedBox(height: 16.h),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.receipt, style: AppTextStyle.cardTitle),
                  SizedBox(height: 10.h),
                  _row(s.business, tx.business.name),
                  _row(s.amountLabel, Helper.formatMoney(tx.amount, tx.currency)),
                  _row(s.date, Helper.formatDateTime(tx.createdAt)),
                  if (tx.gatewayRef != null) _row(s.reference, tx.gatewayRef!, ltr: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (card != null) ...[
                AppButton(
                  label: s.viewCard,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    AppRouteEnum.cardDetails.name,
                    arguments: card.id,
                  ),
                ),
                SizedBox(height: 8.h),
              ],
              AppButton(label: s.done, onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool ltr = false}) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyle.caption)),
          Flexible(
            child: Text(
              value,
              style: AppTextStyle.label,
              textAlign: TextAlign.end,
              textDirection: ltr ? TextDirection.ltr : null,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
