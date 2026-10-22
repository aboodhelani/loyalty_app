import '../../../core/network/dio_network.dart';
import '../../../core/utils/injections.dart';
import 'data/data_sources/remote/explore_api.dart';
import 'data/repositories/explore_repo_impl.dart';
import 'domain/repositories/explore_repo.dart';
import 'domain/usecases/explore_usecases.dart';

initExploreInjections() {
  sl.registerSingleton<ExploreApi>(ExploreApi(DioNetwork.apiClient));
  sl.registerSingleton<ExploreRepo>(ExploreRepoImpl(sl()));
  sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase(sl()));
  sl.registerSingleton<GetNearbyBusinessesUseCase>(GetNearbyBusinessesUseCase(sl()));
  sl.registerSingleton<GetBusinessUseCase>(GetBusinessUseCase(sl()));
}
