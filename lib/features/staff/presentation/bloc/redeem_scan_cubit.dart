import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_events.dart';
import '../../../../shared/domain/models/redemption.dart';
import '../../domain/usecases/staff_usecases.dart';

abstract class RedeemScanState {
  const RedeemScanState();
}

class RedeemScanReady extends RedeemScanState {
  final int session;
  final String? error;
  const RedeemScanReady(this.session, {this.error});
}

class RedeemScanBusy extends RedeemScanState {}

class RedeemScanFound extends RedeemScanState {
  final Redemption redemption;

  /// Exactly what was scanned or typed; confirm sends it back.
  final String code;
  final bool confirming;
  const RedeemScanFound(this.redemption, this.code, {this.confirming = false});
}

class RedeemScanDone extends RedeemScanState {
  final Redemption redemption;
  const RedeemScanDone(this.redemption);
}

/// Staff redeem (S2): scan the redemption code → show reward → Confirm.
class RedeemScanCubit extends Cubit<RedeemScanState> {
  final String businessId;
  final ResolveRedemptionUseCase resolveUseCase;
  final ConfirmRedemptionUseCase confirmUseCase;
  int _session = 0;

  RedeemScanCubit({
    required this.businessId,
    required this.resolveUseCase,
    required this.confirmUseCase,
  }) : super(const RedeemScanReady(0));

  void reset() => emit(RedeemScanReady(++_session));

  Future<void> scanned(String code) async {
    emit(RedeemScanBusy());
    final result = await resolveUseCase(StaffScanParams(businessId: businessId, value: code));
    result.fold(
      (l) => emit(RedeemScanReady(++_session, error: l.errorMessage)),
      (r) => emit(RedeemScanFound(r, code)),
    );
  }

  Future<void> confirm() async {
    final found = state;
    if (found is! RedeemScanFound || found.confirming) return;
    emit(RedeemScanFound(found.redemption, found.code, confirming: true));
    final result = await confirmUseCase(StaffScanParams(businessId: businessId, value: found.code));
    result.fold(
      (l) => emit(RedeemScanReady(++_session, error: l.errorMessage)),
      (_) {
        AppEvents.notifyBusinessChanged(businessId);
        emit(RedeemScanDone(found.redemption));
      },
    );
  }
}
