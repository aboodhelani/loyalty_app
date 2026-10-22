import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/router/app_route_enum.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../shared/presentation/session/session_cubit.dart';
import '../../../../../shared/presentation/widgets/page_header.dart';
import '../../../../../shared/presentation/widgets/state_views.dart';
import '../bloc/wallet_bloc.dart';
import '../widgets/sign_in_prompt.dart';
import '../widgets/stamp_card_tile.dart';
import '../../../../../core/styles/app_icons.dart';
import '../../../../../shared/presentation/widgets/animations.dart';

/// Wallet tab (C8). [onExplore] jumps back to the Explore tab.
class WalletPage extends StatelessWidget {
  final VoidCallback onExplore;

  const WalletPage({super.key, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final signedIn = context.select((SessionCubit c) => c.state.isSignedIn);
    return Scaffold(
      body: !signedIn
          ? Column(
              children: [
                PageHeader(eyebrow: s.yourLoyalty, title: s.walletTitle),
                Expanded(
                  child: SignInPrompt(
                    icon: AppIcons.walletFill,
                    title: s.signInToSeeWallet,
                    message: s.signInToSeeWalletMessage,
                  ),
                ),
              ],
            )
          : BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                final cards = state is WalletLoaded ? state.cards : const [];
                final ready = cards.where((c) => c.isReady).length;
                return RefreshIndicator(
                  onRefresh: () async => context.read<WalletBloc>().add(const LoadWalletEvent(silent: true)),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: PageHeader(
                          eyebrow: s.yourLoyalty,
                          title: s.walletTitle,
                          subtitle: cards.isEmpty ? null : s.walletSubtitle(cards.length, ready),
                        ),
                      ),
                      if (state is WalletError)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: ErrorView(
                            message: state.errorMsg,
                            onRetry: () => context.read<WalletBloc>().add(const LoadWalletEvent()),
                          ),
                        )
                      else if (state is! WalletLoaded)
                        SliverPadding(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
                          sliver: SliverList.separated(
                            itemCount: 3,
                            separatorBuilder: (_, __) => SizedBox(height: 16.h),
                            itemBuilder: (_, __) => Skeleton(height: 190.h, radius: 24),
                          ),
                        )
                      else if (state.cards.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyView(
                            icon: AppIcons.cardsFill,
                            title: s.walletEmptyTitle,
                            message: s.walletEmptyMessage,
                            action: SizedBox(
                              width: 220.w,
                              child: ElevatedButton(onPressed: onExplore, child: Text(s.exploreBusinesses)),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 24.h),
                          sliver: SliverList.separated(
                            itemCount: state.cards.length,
                            separatorBuilder: (_, __) => SizedBox(height: 16.h),
                            itemBuilder: (context, i) {
                              final card = state.cards[i];
                              return FadeSlideIn(
                                index: i,
                                child: StampCardTile(
                                  card: card,
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(AppRouteEnum.cardDetails.name, arguments: card.id),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
