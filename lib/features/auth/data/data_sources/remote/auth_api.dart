import '../../../../../core/network/api_client.dart';
import '../../../../../core/utils/constant/network_constant.dart';
import '../../../../../shared/domain/models/app_user.dart';
import '../../../../../shared/domain/models/json_utils.dart';

/// Token pair + user from `/auth/otp/verify` and `/auth/refresh`.
class AuthSession {
  final String accessToken;
  final String refreshToken;
  final AppUser user;
  final bool profileIncomplete;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.profileIncomplete,
  });

  bool get needsProfile => profileIncomplete || !user.hasProfile;

  factory AuthSession.fromJson(Json json) => AuthSession(
        accessToken: readString(json['accessToken']),
        refreshToken: readString(json['refreshToken']),
        user: AppUser.fromJson(readMap(json['user']) ?? const {}),
        profileIncomplete: json['profileIncomplete'] == true,
      );
}

class AuthApi {
  final ApiClient _client;

  AuthApi(this._client);

  /// Returns seconds until a new code may be requested.
  Future<int> requestOtp(String phone) async {
    final json = await _client.post(authOtpRequestPath, data: {'phone': phone}, skipAuth: true);
    return readInt(json['resendIn'], 30);
  }

  Future<AuthSession> verifyOtp({required String phone, required String code}) async {
    final json = await _client.post(authOtpVerifyPath, data: {'phone': phone, 'code': code}, skipAuth: true);
    return AuthSession.fromJson(json);
  }

  /// Profile plus memberships — decides customer vs business mode.
  Future<AppUser> me() async {
    final json = await _client.get(mePath);
    return AppUser.fromJson(json);
  }

  Future<AppUser> updateProfile({String? name, DateTime? birthday, bool? notificationsEnabled, String? locale}) async {
    final json = await _client.patch(mePath, data: {
      if (name != null) 'name': name,
      if (birthday != null) 'birthday': birthday.toIso8601String().substring(0, 10),
      if (notificationsEnabled != null) 'notificationsEnabled': notificationsEnabled,
      if (locale != null) 'locale': locale,
    });
    return AppUser.fromJson(json);
  }

  Future<void> logout(String refreshToken) async {
    await _client.post(authLogoutPath, data: {'refreshToken': refreshToken});
  }
}
