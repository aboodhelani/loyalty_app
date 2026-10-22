import '../core/network/realtime_service.dart';
import '../core/utils/injections.dart';
import '../core/utils/location_service.dart';
import '../features/auth/data/data_sources/local/auth_shared_prefs.dart';
import 'data/data_sources/app_shared_prefs.dart';

initAppInjections() {
  sl.registerSingleton<AppSharedPrefs>(AppSharedPrefs(sl()));
  sl.registerSingleton<AuthSharedPrefs>(AuthSharedPrefs(sl()));
  sl.registerSingleton<LocationService>(LocationService());
  sl.registerSingleton<RealtimeService>(RealtimeService());
}
