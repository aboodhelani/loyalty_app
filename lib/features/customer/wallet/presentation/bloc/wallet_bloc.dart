import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../../core/utils/app_events.dart';
import '../../../../../core/utils/usecases/usecase.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../domain/usecases/wallet_usecases.dart';

abstract class WalletEvent {
  const WalletEvent();
}

class LoadWalletEvent extends WalletEvent {
  /// Keep the current list on screen while reloading.
  final bool silent;
  const LoadWalletEvent({this.silent = false});
}

/// Signed out: drop the cards.
class ClearWalletEvent extends WalletEvent {
  const ClearWalletEvent();
}

abstract class WalletState {
  const WalletState();
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletError extends WalletState {
  final String errorMsg;
  const WalletError(this.errorMsg);
}

class WalletLoaded extends WalletState {
  /// Ready cards first, then closest to the reward (C8) — sorted by the API.
  final List<StampCard> cards;
  const WalletLoaded(this.cards);
}

/// Wallet tab (C8).
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletCardsUseCase getCardsUseCase;
  StreamSubscription<void>? _walletSub;

  WalletBloc({required this.getCardsUseCase}) : super(WalletInitial()) {
    on<LoadWalletEvent>(_onLoad);
    on<ClearWalletEvent>((_, emitter) => emitter(WalletInitial()));
    _walletSub = AppEvents.walletChanged.listen((_) {
      if (state is! WalletInitial) add(const LoadWalletEvent(silent: true));
    });
  }

  Future<void> _onLoad(LoadWalletEvent event, Emitter<WalletState> emitter) async {
    if (!event.silent || state is! WalletLoaded) emitter(WalletLoading());
    final result = await getCardsUseCase(NoParams());
    result.fold(
      (l) => event.silent && state is WalletLoaded ? null : emitter(WalletError(l.errorMessage)),
      (r) => emitter(WalletLoaded(r)),
    );
  }

  @override
  Future<void> close() {
    _walletSub?.cancel();
    return super.close();
  }
}
