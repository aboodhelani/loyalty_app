import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/constant/local_storage_constants.dart';
import '../../../../../shared/domain/entities/app_mode.dart';
import '../../../../../shared/domain/models/app_user.dart';

class AuthSharedPrefs {
  final SharedPreferences _preferences;

  AuthSharedPrefs(this._preferences);

  /// __________ Token __________ ///
  String? getToken() => _preferences.getString(accessToken);

  Future<void> setToken(String token) => _preferences.setString(accessToken, token);

  String? getRefreshToken() => _preferences.getString(refreshToken);

  Future<void> setTokens({required String access, required String refresh}) async {
    await _preferences.setString(accessToken, access);
    await _preferences.setString(refreshToken, refresh);
  }

  /// __________ Cached user __________ ///
  AppUser? getUser() {
    final raw = _preferences.getString(user);
    if (raw == null) return null;
    try {
      return AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> setUser(AppUser value) => _preferences.setString(user, jsonEncode(value.toJson()));

  /// __________ Last mode, so staff reopen straight into the scanner __________ ///
  AppMode getMode() => AppModeX.fromName(_preferences.getString(appMode));

  Future<void> setMode(AppMode mode) => _preferences.setString(appMode, mode.name);

  String? getActiveBusinessId() => _preferences.getString(activeBusinessId);

  Future<void> setActiveBusinessId(String? id) async {
    if (id == null) {
      await _preferences.remove(activeBusinessId);
    } else {
      await _preferences.setString(activeBusinessId, id);
    }
  }

  Future<void> clearSession() async {
    await _preferences.remove(accessToken);
    await _preferences.remove(refreshToken);
    await _preferences.remove(user);
    await _preferences.remove(appMode);
    await _preferences.remove(activeBusinessId);
  }
}
