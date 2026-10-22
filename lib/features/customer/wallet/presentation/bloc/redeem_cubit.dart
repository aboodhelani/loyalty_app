import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_events.dart';
import '../../../../../shared/domain/models/redemption.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../domain/usecases/wallet_usecases.dart';

abstract class RedeemState {
  const RedeemState();
}

class RedeemLoading extends RedeemState {}

class RedeemError extends RedeemState {
  final String errorMsg;
  const RedeemError(this.errorMsg);
}

/// Showing the one-time code; waiting for staff to confirm (S2).
class RedeemShowingCode extends RedeemState {
  final Redemption redemption;
  const RedeemShowingCode(this.redemption);
}

class RedeemConfirmed extends RedeemState {
  final String rewardText;
  const RedeemConfirmed(this.rewardText);
}

/// Redeem (C11). Confirmation arrives on the socket (`redemption.confirmed`);
/// a slow poll of the card covers a dropped connection.
class RedeemCubit extends Cubit<RedeemState> {
  final String cardId;
  final CreateRedemptionUseCase createRedemptionUseCase;
  final GetStampCardUseCase getCardUseCase;
  Timer? _poll;
  StreamSubscription<void>? _walletSub;
  int? _cycle;

  RedeemCubit({
    required this.cardId,
    required this.createRedemptionUseCase,
    required this.getCardUseCase,
  }) : super(RedeemLoading());

  Future<void> start() async {
    emit(RedeemLoading());
    final card = await getCardUseCase(cardId);
    _cycle = card.fold((_) => null, (c) => c.cycleNumber);
    final result = await createRedemptionUseCase(cardId);
    if (isClosed) return;
    result.fold((l) => emit(RedeemError(l.errorMessage)), (r) {
      emit(RedeemShowingCode(r));
      _poll?.cancel();
      _poll = Timer.periodic(const Duration(seconds: 4), (_) => _check());
      _walletSub ??= AppEvents.walletChanged.listen((_) => _check());
    });
  }

  Future<void> _check() async {
    final showing = state;
    if (showing is! RedeemShowingCode) return;
    final result = await getCardUseCase(cardId);
    if (isClosed) return;
    result.fold((_) {}, (StampCard card) {
      final redeemed =
          card.activeRedemption == null && (card.cycleNumber > (_cycle ?? card.cycleNumber) || !card.isReady);
      if (redeemed) {
        _poll?.cancel();
        emit(RedeemConfirmed(
            showing.redemption.rewardText.isNotEmpty ? showing.redemption.rewardText : card.rewardText));
      }
    });
  }

  @override
  Future<void> close() {
    _poll?.cancel();
    _walletSub?.cancel();
    return super.close();
  }
}
