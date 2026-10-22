import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../data/data_sources/remote/auth_api.dart';
import '../repositories/auth_repo.dart';

class RequestOtpUseCase extends UseCase<int, String> {
  final AuthRepo repository;

  RequestOtpUseCase(this.repository);

  /// Returns seconds until a resend is allowed.
  @override
  Future<Either<Failure, int>> call(String phone) => repository.requestOtp(phone);
}

class VerifyOtpParams {
  final String phone;
  final String code;

  const VerifyOtpParams({required this.phone, required this.code});
}

class VerifyOtpUseCase extends UseCase<AuthSession, VerifyOtpParams> {
  final AuthRepo repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthSession>> call(VerifyOtpParams params) =>
      repository.verifyOtp(phone: params.phone, code: params.code);
}

class UpdateProfileParams {
  final String? name;
  final DateTime? birthday;
  final bool? notificationsEnabled;
  final String? locale;

  const UpdateProfileParams({this.name, this.birthday, this.notificationsEnabled, this.locale});
}

class UpdateProfileUseCase extends UseCase<AppUser, UpdateProfileParams> {
  final AuthRepo repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(UpdateProfileParams params) => repository.updateProfile(
        name: params.name,
        birthday: params.birthday,
        notificationsEnabled: params.notificationsEnabled,
        locale: params.locale,
      );
}

class GetMeUseCase extends UseCase<AppUser, NoParams> {
  final AuthRepo repository;

  GetMeUseCase(this.repository);

  @override
  Future<Either<Failure, AppUser>> call(NoParams params) => repository.me();
}

class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepo repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.logout();
}
