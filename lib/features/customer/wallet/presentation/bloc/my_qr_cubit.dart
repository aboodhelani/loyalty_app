import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/usecases/usecase.dart';
import '../../../../../shared/domain/models/qr_token.dart';
import '../../domain/usecases/wallet_usecases.dart';

class MyQrState {
  final QrToken? token;
  final int secondsLeft;
  final String? error;

  const MyQrState({this.token, this.secondsLeft = 0, this.error});
}

/// My QR (C10): a server-signed token that rotates every 30 seconds, so a
/// screenshot can't be reused (spec §8.8).
class MyQrCubit extends Cubit<MyQrState> {
  final GetQrTokenUseCase getQrTokenUseCase;
  Timer? _ticker;
  bool _fetching = false;

  MyQrCubit({required this.getQrTokenUseCase}) : super(const MyQrState());

  Future<void> start() async {
    await _refresh();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void stop() => _ticker?.cancel();

  Future<void> _refresh() async {
    if (_fetching) return;
    _fetching = true;
    final result = await getQrTokenUseCase(NoParams());
    _fetching = false;
    if (isClosed) return;
    result.fold(
      (l) => emit(MyQrState(token: state.token, error: l.errorMessage)),
      (token) => emit(MyQrState(token: token, secondsLeft: _secondsUntil(token.expiresAt))),
    );
  }

  void _tick() {
    final token = state.token;
    if (token == null) {
      _refresh();
      return;
    }
    final left = _secondsUntil(token.expiresAt);
    if (left <= 0) {
      _refresh();
    } else {
      emit(MyQrState(token: token, secondsLeft: left));
    }
  }

  static int _secondsUntil(DateTime t) => t.difference(DateTime.now()).inMilliseconds ~/ 1000 + 1;

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
