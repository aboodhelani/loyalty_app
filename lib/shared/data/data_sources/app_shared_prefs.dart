import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/constant/local_storage_constants.dart';

class AppSharedPrefs {
  final SharedPreferences _preferences;

  AppSharedPrefs(this._preferences);

  /// __________ Onboarding (C1) __________ ///
  bool getOnboardingSeen() {
    return _preferences.getBool(onboardingSeen) ?? false;
  }

  void setOnboardingSeen() {
    _preferences.setBool(onboardingSeen, true);
  }

  /// __________ Notifications (C12) __________ ///
  bool getNotificationsEnabled() {
    return _preferences.getBool(notificationsEnabled) ?? true;
  }

  void setNotificationsEnabled(bool value) {
    _preferences.setBool(notificationsEnabled, value);
  }
}
