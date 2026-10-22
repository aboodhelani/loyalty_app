import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/error/failures.dart';
import '../../../core/network/realtime_service.dart';
import '../../../core/utils/app_events.dart';
import '../../../core/utils/usecases/usecase.dart';
import '../../../features/auth/data/data_sources/local/auth_shared_prefs.dart';
import '../../../features/auth/domain/usecases/auth_usecases.dart';
import '../../domain/entities/app_mode.dart';
import '../../domain/models/app_user.dart';
import 'session_state.dart';

export 'session_state.dart';

/// Who is signed in and which role shell is showing. Lives above the
/// navigator, so every page reads the same session.
class SessionCubit extends Cubit<SessionState> {
  final GetMeUseCase getMeUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthSharedPrefs authPrefs;
  final RealtimeService realtime;
  StreamSubscription<void>? _expiredSub;

  SessionCubit({
    required this.getMeUseCase,
    required this.logoutUseCase,
    required this.authPrefs,
    required this.realtime,
  }) : super(const SessionState()) {
    _expiredSub = AppEvents.sessionExpired.listen((_) {
      realtime.disconnect();
      emit(const SessionState());
    });
  }

  /// Restores the last session on launch. A cached user keeps the app usable
  /// when the API is slow to wake; a 401 (after a failed refresh) signs out.
  Future<void> restore() async {
    if (authPrefs.getToken() == null) {
      emit(const SessionState());
      return;
    }
    final cached = authPrefs.getUser();
    final result = await getMeUseCase(NoParams());
    final user = result.fold((l) => _isUnauthorized(l) ? null : cached, (r) => r);
    if (user == null) {
      await authPrefs.clearSession();
      emit(const SessionState());
      return;
    }
    _emitFor(user, authPrefs.getMode(), authPrefs.getActiveBusinessId());
    realtime.connect();
  }

  bool _isUnauthorized(Failure failure) => failure is ServerFailure && failure.statusCode == 401;

  void signedIn(AppUser user) {
    _emitFor(user, AppMode.customer, null);
    realtime.connect();
  }

  void userUpdated(AppUser user) => _emitFor(user, state.mode, state.activeBusinessId);

  /// Re-reads memberships, e.g. after an owner adds this user as staff.
  Future<void> refreshUser() async {
    final result = await getMeUseCase(NoParams());
    result.fold((_) {}, userUpdated);
  }

  /// Switches shells. Falls back to customer mode when the user has no
  /// business that allows [mode].
  Future<void> switchMode(AppMode mode, {String? businessId}) async {
    final user = state.user;
    if (user == null) return;
    _emitFor(user, mode, businessId ?? state.activeBusinessId);
  }

  Future<void> logout() async {
    realtime.disconnect();
    await logoutUseCase(NoParams());
    emit(const SessionState());
  }

  void _emitFor(AppUser user, AppMode mode, String? businessId) {
    final candidates = membershipsFor(user, mode);
    final active = candidates.isEmpty
        ? null
        : candidates.firstWhere((m) => m.businessId == businessId, orElse: () => candidates.first);
    final next = active == null
        ? SessionState(user: user, mode: AppMode.customer)
        : SessionState(user: user, mode: mode, activeBusinessId: active.businessId);
    authPrefs.setMode(next.mode);
    authPrefs.setActiveBusinessId(next.activeBusinessId);
    emit(next);
  }

  /// Businesses that allow [mode]. Owners may also work the counter (staff
  /// mode) at their own businesses.
  static List<BusinessMembership> membershipsFor(AppUser user, AppMode mode) {
    switch (mode) {
      case AppMode.customer:
        return const [];
      case AppMode.owner:
        return user.memberships.where((m) => m.role == BusinessRole.owner).toList();
      case AppMode.staff:
        return user.memberships;
    }
  }

  /// Modes this user can switch to, for the profile switcher.
  static List<AppMode> availableModes(AppUser? user) {
    if (user == null) return const [AppMode.customer];
    return [
      AppMode.customer,
      if (user.memberships.any((m) => m.role == BusinessRole.owner)) AppMode.owner,
      if (user.memberships.isNotEmpty) AppMode.staff,
    ];
  }

  @override
  Future<void> close() {
    _expiredSub?.cancel();
    return super.close();
  }
}
