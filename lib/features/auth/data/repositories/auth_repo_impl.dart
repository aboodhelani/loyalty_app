import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/network/error/guard.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../domain/repositories/auth_repo.dart';
import '../data_sources/local/auth_shared_prefs.dart';
import '../data_sources/remote/auth_api.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthApi api;
  final AuthSharedPrefs prefs;

  AuthRepoImpl(this.api, this.prefs);

  @override
  Future<Either<Failure, int>> requestOtp(String phone) => guardRequest(() => api.requestOtp(phone));

  @override
  Future<Either<Failure, AuthSession>> verifyOtp({required String phone, required String code}) {
    return guardRequest(() async {
      final session = await api.verifyOtp(phone: phone, code: code);
      await prefs.setTokens(access: session.accessToken, refresh: session.refreshToken);
      // The verify payload has no memberships; /me decides business mode.
      final user = await api.me();
      await prefs.setUser(user);
      return AuthSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        user: user,
        profileIncomplete: session.profileIncomplete,
      );
    });
  }

  @override
  Future<Either<Failure, AppUser>> me() {
    return guardRequest(() async {
      final user = await api.me();
      await prefs.setUser(user);
      return user;
    });
  }

  @override
  Future<Either<Failure, AppUser>> updateProfile({
    String? name,
    DateTime? birthday,
    bool? notificationsEnabled,
    String? locale,
  }) {
    return guardRequest(() async {
      final updated = await api.updateProfile(
        name: name,
        birthday: birthday,
        notificationsEnabled: notificationsEnabled,
        locale: locale,
      );
      final user = (prefs.getUser() ?? updated).mergeProfile(updated);
      await prefs.setUser(user);
      return user;
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final refresh = prefs.getRefreshToken();
    if (refresh != null) await guardRequest(() => api.logout(refresh));
    await prefs.clearSession();
    return const Right(null);
  }
}
