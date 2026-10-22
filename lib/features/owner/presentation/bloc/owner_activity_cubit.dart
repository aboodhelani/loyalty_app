import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_events.dart';
import '../../../../shared/domain/models/activity_summary.dart';
import '../../domain/usecases/owner_usecases.dart';

abstract class OwnerActivityState {
  final ActivityRange range;
  const OwnerActivityState(this.range);
}

class OwnerActivityLoading extends OwnerActivityState {
  const OwnerActivityLoading(super.range);
}

class OwnerActivityError extends OwnerActivityState {
  final String errorMsg;
  const OwnerActivityError(super.range, this.errorMsg);
}

class OwnerActivityLoaded extends OwnerActivityState {
  final ActivitySummary summary;
  const OwnerActivityLoaded(super.range, this.summary);
}

/// Activity (B4): today and last 7/30 days. Live business events reload it.
class OwnerActivityCubit extends Cubit<OwnerActivityState> {
  final String businessId;
  final GetActivityUseCase getActivityUseCase;
  StreamSubscription<String?>? _sub;
  StreamSubscription<String>? _paymentSub;

  OwnerActivityCubit({required this.businessId, required this.getActivityUseCase})
      : super(const OwnerActivityLoading(ActivityRange.today)) {
    _sub = AppEvents.businessChanged.listen((id) {
      if (id == null || id == businessId) load(state.range, silent: true);
    });
    _paymentSub = AppEvents.paymentReceived.listen((_) => load(state.range, silent: true));
  }

  Future<void> load(ActivityRange range, {bool silent = false}) async {
    if (!silent || state is! OwnerActivityLoaded) emit(OwnerActivityLoading(range));
    final result = await getActivityUseCase(ActivityParams(businessId, range));
    if (isClosed) return;
    result.fold(
      (l) => silent && state is OwnerActivityLoaded ? null : emit(OwnerActivityError(range, l.errorMessage)),
      (r) => emit(OwnerActivityLoaded(range, r)),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _paymentSub?.cancel();
    return super.close();
  }
}
