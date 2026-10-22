import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/usecases/usecase.dart';
import '../../../../../shared/domain/models/visit_entry.dart';
import '../../../wallet/domain/usecases/wallet_usecases.dart';

abstract class VisitHistoryState {
  const VisitHistoryState();
}

class VisitHistoryLoading extends VisitHistoryState {}

class VisitHistoryError extends VisitHistoryState {
  final String errorMsg;
  const VisitHistoryError(this.errorMsg);
}

class VisitHistoryLoaded extends VisitHistoryState {
  final List<VisitEntry> visits;
  const VisitHistoryLoaded(this.visits);
}

/// Visit history (C12).
class VisitHistoryCubit extends Cubit<VisitHistoryState> {
  final GetVisitHistoryUseCase getVisitHistoryUseCase;

  VisitHistoryCubit({required this.getVisitHistoryUseCase}) : super(VisitHistoryLoading());

  Future<void> load() async {
    emit(VisitHistoryLoading());
    final result = await getVisitHistoryUseCase(NoParams());
    if (isClosed) return;
    result.fold((l) => emit(VisitHistoryError(l.errorMessage)), (r) => emit(VisitHistoryLoaded(r)));
  }
}
