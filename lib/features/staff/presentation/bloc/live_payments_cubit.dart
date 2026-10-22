import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_events.dart';
import '../../../../shared/domain/models/transaction.dart';
import '../../domain/usecases/staff_usecases.dart';

abstract class LivePaymentsState {
  const LivePaymentsState();
}

class LivePaymentsLoading extends LivePaymentsState {}

class LivePaymentsError extends LivePaymentsState {
  final String errorMsg;
  const LivePaymentsError(this.errorMsg);
}

class LivePaymentsLoaded extends LivePaymentsState {
  final List<PaymentTransaction> payments;

  /// Ids that arrived since the screen opened — highlighted briefly.
  final Set<String> fresh;
  const LivePaymentsLoaded(this.payments, {this.fresh = const {}});
}

/// Live payments (S3). The socket's `payment.succeeded` triggers a reload, so
/// a payment shows within seconds (spec §11); a slow poll covers a dropped
/// connection.
class LivePaymentsCubit extends Cubit<LivePaymentsState> {
  final String businessId;
  final GetTodaysPaymentsUseCase getPaymentsUseCase;
  StreamSubscription<String>? _sub;
  Timer? _poll;

  LivePaymentsCubit({required this.businessId, required this.getPaymentsUseCase}) : super(LivePaymentsLoading()) {
    _sub = AppEvents.paymentReceived.listen((id) {
      if (id.isEmpty || id == businessId) load(silent: true);
    });
    _poll = Timer.periodic(const Duration(seconds: 20), (_) => load(silent: true));
  }

  Future<void> load({bool silent = false}) async {
    final previous = state is LivePaymentsLoaded ? (state as LivePaymentsLoaded).payments : null;
    if (!silent || previous == null) emit(LivePaymentsLoading());
    final result = await getPaymentsUseCase(businessId);
    if (isClosed) return;
    result.fold(
      (l) => previous == null ? emit(LivePaymentsError(l.errorMessage)) : null,
      (list) {
        final known = previous?.map((p) => p.id).toSet();
        final fresh = known == null ? <String>{} : list.map((p) => p.id).where((id) => !known.contains(id)).toSet();
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(LivePaymentsLoaded(list, fresh: fresh));
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _poll?.cancel();
    return super.close();
  }
}
