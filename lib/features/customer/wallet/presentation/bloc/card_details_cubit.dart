import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_events.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../domain/usecases/wallet_usecases.dart';

abstract class CardDetailsState {
  const CardDetailsState();
}

class CardDetailsLoading extends CardDetailsState {}

class CardDetailsError extends CardDetailsState {
  final String errorMsg;
  const CardDetailsError(this.errorMsg);
}

class CardDetailsLoaded extends CardDetailsState {
  final StampCard card;
  const CardDetailsLoaded(this.card);
}

/// Stamp card detail (C9).
class CardDetailsCubit extends Cubit<CardDetailsState> {
  final String cardId;
  final GetStampCardUseCase getCardUseCase;
  StreamSubscription<void>? _walletSub;

  CardDetailsCubit({required this.cardId, required this.getCardUseCase}) : super(CardDetailsLoading()) {
    _walletSub = AppEvents.walletChanged.listen((_) => load(silent: true));
  }

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(CardDetailsLoading());
    final result = await getCardUseCase(cardId);
    if (isClosed) return;
    result.fold(
      (l) => silent ? null : emit(CardDetailsError(l.errorMessage)),
      (card) => emit(CardDetailsLoaded(card)),
    );
  }

  @override
  Future<void> close() {
    _walletSub?.cancel();
    return super.close();
  }
}
