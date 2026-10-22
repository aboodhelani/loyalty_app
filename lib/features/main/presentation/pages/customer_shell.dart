import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/location_service.dart';
import '../../../../shared/presentation/session/session_cubit.dart';
import '../../../customer/explore/domain/usecases/explore_usecases.dart';
import '../../../customer/explore/presentation/bloc/explore_bloc.dart';
import '../../../customer/explore/presentation/pages/explore_page.dart';
import '../../../customer/profile/presentation/pages/profile_page.dart';
import '../../../customer/wallet/domain/usecases/wallet_usecases.dart';
import '../../../customer/wallet/presentation/bloc/wallet_bloc.dart';
import '../../../customer/wallet/presentation/pages/my_qr_page.dart';
import '../../../customer/wallet/presentation/pages/wallet_page.dart';
import '../../../../shared/presentation/widgets/app_nav_bar.dart';
import '../widgets/notice_listener.dart';
import '../../../../core/styles/app_icons.dart';

/// Customer app: Explore · Wallet · Scan (centre) · Profile (spec §5).
class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  static const _scanTab = 2;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExploreBloc(
            getCategoriesUseCase: sl<GetCategoriesUseCase>(),
            getNearbyBusinessesUseCase: sl<GetNearbyBusinessesUseCase>(),
            locationService: sl<LocationService>(),
          )..add(const LoadExploreEvent()),
        ),
        BlocProvider(create: (_) => WalletBloc(getCardsUseCase: sl<GetWalletCardsUseCase>())),
      ],
      child: Builder(builder: (context) {
        return BlocListener<SessionCubit, SessionState>(
          // Signing in or out changes the wallet and the map progress.
          listenWhen: (a, b) => a.user?.id != b.user?.id,
          listener: (context, state) {
            final wallet = context.read<WalletBloc>();
            wallet.add(state.isSignedIn ? const LoadWalletEvent() : const ClearWalletEvent());
            context.read<ExploreBloc>().add(const RefreshExploreEvent());
          },
          child: _LoadWalletOnce(
            child: NoticeListener(
              child: Scaffold(
                // The Explore map runs full height, under the floating nav bar.
                extendBody: _index == 0,
                body: IndexedStack(
                  index: _index,
                  children: [
                    const ExplorePage(),
                    WalletPage(onExplore: () => setState(() => _index = 0)),
                    // Mounted only while visible, so the QR only rotates on screen.
                    _index == _scanTab ? const MyQrPage() : const SizedBox.shrink(),
                    const ProfilePage(),
                  ],
                ),
                bottomNavigationBar: AppNavBar(
                  index: _index,
                  onChanged: (i) => setState(() => _index = i),
                  items: [
                    AppNavItem(AppIcons.compass, AppIcons.compassFill, s.tabExplore),
                    AppNavItem(AppIcons.wallet, AppIcons.walletFill, s.tabWallet),
                    AppNavItem(AppIcons.scan, AppIcons.qrCode, s.tabScan),
                    AppNavItem(AppIcons.user, AppIcons.userFill, s.tabProfile),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Loads the wallet when the shell opens with a restored session.
class _LoadWalletOnce extends StatefulWidget {
  final Widget child;

  const _LoadWalletOnce({required this.child});

  @override
  State<_LoadWalletOnce> createState() => _LoadWalletOnceState();
}

class _LoadWalletOnceState extends State<_LoadWalletOnce> {
  @override
  void initState() {
    super.initState();
    if (context.read<SessionCubit>().state.isSignedIn) context.read<WalletBloc>().add(const LoadWalletEvent());
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
