import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth_injections.dart';
import '../../features/customer/explore/explore_injections.dart';
import '../../features/customer/payment/payment_injections.dart';
import '../../features/customer/wallet/wallet_injections.dart';
import '../../features/owner/owner_injections.dart';
import '../../features/staff/staff_injections.dart';
import '../../shared/app_injections.dart';
import '../network/dio_network.dart';
import 'log/app_logger.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  await initSharedPrefsInjections();
  await initAppInjections();
  await initDioInjections();
  await initAuthInjections();
  await initExploreInjections();
  await initPaymentInjections();
  await initWalletInjections();
  await initStaffInjections();
  await initOwnerInjections();
}

initSharedPrefsInjections() async {
  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  await sl.isReady<SharedPreferences>();
}

Future<void> initDioInjections() async {
  initRootLogger();
  DioNetwork.initDio();
}
