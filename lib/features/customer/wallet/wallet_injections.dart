import '../../../core/network/dio_network.dart';
import '../../../core/utils/injections.dart';
import 'data/data_sources/remote/wallet_api.dart';
import 'data/repositories/wallet_repo_impl.dart';
import 'domain/repositories/wallet_repo.dart';
import 'domain/usecases/wallet_usecases.dart';

initWalletInjections() {
  sl.registerSingleton<WalletApi>(WalletApi(DioNetwork.apiClient));
  sl.registerSingleton<WalletRepo>(WalletRepoImpl(sl()));
  sl.registerSingleton<GetWalletCardsUseCase>(GetWalletCardsUseCase(sl()));
  sl.registerSingleton<GetStampCardUseCase>(GetStampCardUseCase(sl()));
  sl.registerSingleton<GetQrTokenUseCase>(GetQrTokenUseCase(sl()));
  sl.registerSingleton<CreateRedemptionUseCase>(CreateRedemptionUseCase(sl()));
  sl.registerSingleton<GetVisitHistoryUseCase>(GetVisitHistoryUseCase(sl()));
}
