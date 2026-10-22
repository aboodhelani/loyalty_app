import '../../../../shared/domain/models/app_user.dart';

enum AuthStep { phone, code, profile, done }

class AuthState {
  final AuthStep step;
  final String phone;
  final bool loading;

  /// Seconds until "Resend code" unlocks.
  final int resendIn;
  final AppUser? user;

  /// One-shot message for the page to surface, cleared on the next event.
  final String? error;

  const AuthState({
    this.step = AuthStep.phone,
    this.phone = '',
    this.loading = false,
    this.resendIn = 0,
    this.user,
    this.error,
  });

  AuthState copyWith({AuthStep? step, String? phone, bool? loading, int? resendIn, AppUser? user, String? error}) {
    return AuthState(
      step: step ?? this.step,
      phone: phone ?? this.phone,
      loading: loading ?? this.loading,
      resendIn: resendIn ?? this.resendIn,
      user: user ?? this.user,
      error: error,
    );
  }
}
