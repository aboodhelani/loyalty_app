import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_events.dart';
import '../../../../shared/domain/models/scan_result.dart';
import '../../domain/usecases/staff_usecases.dart';

abstract class StampScanState {
  const StampScanState();
}

class StampScanReady extends StampScanState {
  /// Bumped on every reset so the scanner widget remounts with a live camera.
  final int session;

  /// One-shot error from the last attempt.
  final String? error;
  const StampScanReady(this.session, {this.error});
}

class StampScanBusy extends StampScanState {}

class StampScanFound extends StampScanState {
  final ScanResult result;
  final String qrToken;
  final bool stamping;
  const StampScanFound(this.result, this.qrToken, {this.stamping = false});
}

class StampScanDone extends StampScanState {
  final String firstName;
  final StaffStampResult stamp;
  const StampScanDone(this.firstName, this.stamp);
}

/// Staff scan (S1): QR → customer + progress → Add stamp → confirmation.
class StampScanCubit extends Cubit<StampScanState> {
  final String businessId;
  final ScanCustomerUseCase scanCustomerUseCase;
  final AddStampUseCase addStampUseCase;
  int _session = 0;

  StampScanCubit({
    required this.businessId,
    required this.scanCustomerUseCase,
    required this.addStampUseCase,
  }) : super(const StampScanReady(0));

  void reset() => emit(StampScanReady(++_session));

  Future<void> scanned(String qrToken) async {
    emit(StampScanBusy());
    final result = await scanCustomerUseCase(StaffScanParams(businessId: businessId, value: qrToken));
    result.fold(
      (l) => emit(StampScanReady(++_session, error: l.errorMessage)),
      (r) => emit(StampScanFound(r, qrToken)),
    );
  }

  Future<void> addStamp() async {
    final found = state;
    if (found is! StampScanFound || found.stamping) return;
    emit(StampScanFound(found.result, found.qrToken, stamping: true));
    final result = await addStampUseCase(StaffScanParams(businessId: businessId, value: found.qrToken));
    result.fold(
      // e.g. DAILY_LIMIT_REACHED — the server message is already customer-ready.
      (l) => emit(StampScanReady(++_session, error: l.errorMessage)),
      (r) {
        AppEvents.notifyBusinessChanged(businessId);
        emit(StampScanDone(found.result.firstName, r));
      },
    );
  }
}
