import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../data/data_sources/remote/auth_api.dart';

abstract class AuthRepo {
  /// Returns seconds until a resend is allowed.
  Future<Either<Failure, int>> requestOtp(String phone);

  /// Stores the session on success; the returned user includes memberships.
  Future<Either<Failure, AuthSession>> verifyOtp({required String phone, required String code});

  Future<Either<Failure, AppUser>> me();

  Future<Either<Failure, AppUser>> updateProfile({
    String? name,
    DateTime? birthday,
    bool? notificationsEnabled,
    String? locale,
  });

  /// Always clears the local session, even when the server call fails.
  Future<Either<Failure, void>> logout();
}
