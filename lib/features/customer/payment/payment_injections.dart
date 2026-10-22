import '../../../core/network/dio_network.dart';
import '../../../core/utils/injections.dart';
import 'data/data_sources/remote/payment_api.dart';
import 'data/data_sources/remote/wallet_pay_service.dart';
import 'data/repositories/payment_repo_impl.dart';
import 'domain/repositories/payment_repo.dart';
import 'domain/usecases/payment_usecases.dart';

initPaymentInjections() {
  sl.registerSingleton<PaymentApi>(PaymentApi(DioNetwork.apiClient));
  sl.registerSingleton<WalletPayService>(WalletPayService());
  sl.registerSingleton<PaymentRepo>(PaymentRepoImpl(sl(), sl()));
  sl.registerSingleton<CreatePaymentUseCase>(CreatePaymentUseCase(sl()));
  sl.registerSingleton<AuthorizePaymentUseCase>(AuthorizePaymentUseCase(sl()));
  sl.registerSingleton<AwaitPaymentResultUseCase>(AwaitPaymentResultUseCase(sl()));
}
