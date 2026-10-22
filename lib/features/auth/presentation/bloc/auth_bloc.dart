import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/utils/validators/phone_validator.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

/// Phone → OTP → (new users) name & birthday. Opened on the first Pay or Scan,
/// never on app launch (C2).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  Timer? _resendTimer;

  AuthBloc({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.updateProfileUseCase,
  }) : super(const AuthState()) {
    on<AuthPhoneSubmitted>(_onPhone);
    on<AuthCodeSubmitted>(_onCode);
    on<AuthResendRequested>(_onResend);
    on<AuthChangeNumberRequested>(_onChangeNumber);
    on<AuthProfileSubmitted>(_onProfile);
    on<AuthResendTicked>(_onTick);
  }

  Future<void> _onPhone(AuthPhoneSubmitted event, Emitter<AuthState> emitter) async {
    final phone = PhoneValidator.normalize(event.phone);
    emitter(state.copyWith(loading: true, phone: phone));
    final result = await requestOtpUseCase(phone);
    result.fold(
      (l) => emitter(state.copyWith(loading: false, error: l.errorMessage)),
      (resendIn) {
        emitter(state.copyWith(loading: false, step: AuthStep.code, resendIn: resendIn));
        _startResendTimer();
      },
    );
  }

  Future<void> _onCode(AuthCodeSubmitted event, Emitter<AuthState> emitter) async {
    if (state.loading) return;
    emitter(state.copyWith(loading: true));
    final result = await verifyOtpUseCase(VerifyOtpParams(phone: state.phone, code: event.code));
    result.fold(
      (l) => emitter(state.copyWith(loading: false, error: l.errorMessage)),
      (session) {
        _resendTimer?.cancel();
        emitter(state.copyWith(
          loading: false,
          user: session.user,
          step: session.needsProfile ? AuthStep.profile : AuthStep.done,
        ));
      },
    );
  }

  Future<void> _onResend(AuthResendRequested event, Emitter<AuthState> emitter) async {
    if (state.resendIn > 0) return;
    final result = await requestOtpUseCase(state.phone);
    result.fold(
      (l) => emitter(state.copyWith(error: l.errorMessage)),
      (resendIn) {
        emitter(state.copyWith(resendIn: resendIn));
        _startResendTimer();
      },
    );
  }

  void _onChangeNumber(AuthChangeNumberRequested event, Emitter<AuthState> emitter) {
    _resendTimer?.cancel();
    emitter(state.copyWith(step: AuthStep.phone, resendIn: 0));
  }

  Future<void> _onProfile(AuthProfileSubmitted event, Emitter<AuthState> emitter) async {
    emitter(state.copyWith(loading: true));
    final result = await updateProfileUseCase(UpdateProfileParams(name: event.name, birthday: event.birthday));
    result.fold(
      (l) => emitter(state.copyWith(loading: false, error: l.errorMessage)),
      (user) => emitter(state.copyWith(loading: false, user: user, step: AuthStep.done)),
    );
  }

  void _onTick(AuthResendTicked event, Emitter<AuthState> emitter) {
    final next = state.resendIn - 1;
    emitter(state.copyWith(resendIn: next < 0 ? 0 : next));
    if (next <= 0) _resendTimer?.cancel();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) => add(const AuthResendTicked()));
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
