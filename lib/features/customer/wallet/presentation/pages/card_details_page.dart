import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/helper.dart';
import '../../../../../core/router/app_route_enum.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../core/utils/injections.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../../../../shared/presentation/widgets/app_button.dart';
import '../../../../../shared/presentation/widgets/app_card.dart';
import '../../../../../shared/presentation/widgets/icon_badge.dart';
import '../../../../../shared/presentation/widgets/section_header.dart';
import '../../../../../shared/presentation/widgets/stamp_progress.dart';
import '../../../../../shared/presentation/widgets/state_views.dart';
import '../../domain/usecases/wallet_usecases.dart';
import '../bloc/card_details_cubit.dart';
import '../widgets/stamp_card_tile.dart';
import '../../../../../core/styles/app_icons.dart';

/// Stamp card detail (C9): the card, its stamp grid, terms and history.
class CardDetailsPage extends StatelessWidget {
  final String cardId;

  const CardDetailsPage({super.key, required this.cardId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CardDetailsCubit(cardId: cardId, getCardUseCase: sl<GetStampCardUseCase>())..load(),
      child: BlocBuilder<CardDetailsCubit, CardDetailsState>(
        builder: (context, state) {
          final card = state is CardDetailsLoaded ? state.card : null;
          return Scaffold(
            appBar: AppBar(title: Text(card?.business.name ?? '')),
            body: switch (state) {
              CardDetailsLoaded(:final card) => _CardBody(card: card),
              CardDetailsError(:final errorMsg) =>
                ErrorView(message: errorMsg, onRetry: () => context.read<CardDetailsCubit>().load()),
              _ => const LoadingView(),
            },
            bottomNavigationBar: card != null && card.isReady
                ? SafeArea(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 12.h),
                      child: AppButton(
                        label: S.of(context).redeem,
                        icon: AppIcons.gift,
                        onPressed: () => Navigator.of(context).pushNamed(AppRouteEnum.redeem.name, arguments: card.id),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final StampCard card;

  const _CardBody({required this.card});

  String _sourceLabel(S s, StampSource source) {
    switch (source) {
      case StampSource.payment:
        return s.stampSourcePayment;
      case StampSource.staffScan:
        return s.stampSourceStaff;
      case StampSource.admin:
        return s.stampSourceAdmin;
    }
  }

  IconData _sourceIcon(StampSource source) => switch (source) {
        StampSource.payment => AppIcons.contactless,
        StampSource.staffScan => AppIcons.scan,
        StampSource.admin => AppIcons.support,
      };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final history = [...card.stamps]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final terms = [
      s.programCollect(card.stampsRequired, card.rewardText),
      if (card.program != null) s.stampExpiryNote(card.program!.stampExpiryDays),
      if ((card.terms ?? card.program?.terms)?.isNotEmpty ?? false) (card.terms ?? card.program!.terms)!,
    ];
    return ListView(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 32.h),
      children: [
        StampCardTile(card: card),
        SizedBox(height: 20.h),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(s.cycleLabel(card.cycleNumber).toUpperCase(), style: AppTextStyle.eyebrow)),
                  Text(
                    card.isReady ? s.readyToRedeem : s.stampsToGo(card.remaining),
                    style: AppTextStyle.small.copyWith(
                      color: card.isReady ? AppColors.warningAccent : AppColors.foregroundMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Center(child: StampGrid(filled: card.stampsCount, total: card.stampsRequired)),
            ],
          ),
        ),
        SectionHeader(title: s.howItWorks),
        AppCard(
          child: Column(
            children: [
              for (var i = 0; i < terms.length; i++) ...[
                if (i > 0) SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22.sp,
                      height: 22.sp,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.brandCream, shape: BoxShape.circle),
                      child: Text('${i + 1}',
                          style: AppTextStyle.small.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(child: Text(terms[i], style: AppTextStyle.body)),
                  ],
                ),
              ],
            ],
          ),
        ),
        SectionHeader(title: s.stampHistory),
        if (history.isEmpty)
          Text(s.noStampsYet, style: AppTextStyle.caption)
        else
          AppCard(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 6.h),
            child: Column(
              children: [
                for (var i = 0; i < history.length; i++)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Timeline rail
                        SizedBox(
                          width: 40.sp,
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(width: 2, color: i == 0 ? Colors.transparent : AppColors.border)),
                              IconBadge(icon: _sourceIcon(history[i].source), size: 36),
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: i == history.length - 1 ? Colors.transparent : AppColors.border,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.symmetric(vertical: 12.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_sourceLabel(s, history[i].source), style: AppTextStyle.label),
                                if (history[i].branch != null)
                                  Text(history[i].branch!.name, style: AppTextStyle.caption),
                              ],
                            ),
                          ),
                        ),
                        Center(child: Text(Helper.formatDate(history[i].createdAt), style: AppTextStyle.caption)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
