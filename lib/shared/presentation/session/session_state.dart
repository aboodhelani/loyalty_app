import '../../domain/entities/app_mode.dart';
import '../../domain/models/app_user.dart';

class SessionState {
  /// Null while browsing as a guest (C1: "Continue" without signing up).
  final AppUser? user;
  final AppMode mode;

  /// Business the owner/staff shell is working on.
  final String? activeBusinessId;

  const SessionState({this.user, this.mode = AppMode.customer, this.activeBusinessId});

  bool get isSignedIn => user != null;

  BusinessMembership? get activeMembership {
    final u = user;
    if (u == null || activeBusinessId == null) return null;
    for (final m in u.memberships) {
      if (m.businessId == activeBusinessId) return m;
    }
    return null;
  }

  SessionState copyWith({AppUser? user, AppMode? mode, String? activeBusinessId}) => SessionState(
        user: user ?? this.user,
        mode: mode ?? this.mode,
        activeBusinessId: activeBusinessId ?? this.activeBusinessId,
      );
}
