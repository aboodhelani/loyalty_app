import '../../core/network/dio_network.dart';
import '../../core/utils/injections.dart';
import 'data/data_sources/remote/owner_api.dart';
import 'data/repositories/owner_repo_impl.dart';
import 'domain/repositories/owner_repo.dart';
import 'domain/usecases/owner_usecases.dart';

initOwnerInjections() {
  sl.registerSingleton<OwnerApi>(OwnerApi(DioNetwork.apiClient));
  sl.registerSingleton<OwnerRepo>(OwnerRepoImpl(sl()));
  sl.registerSingleton<GetOwnerBusinessUseCase>(GetOwnerBusinessUseCase(sl()));
  sl.registerSingleton<UpdateBusinessProfileUseCase>(UpdateBusinessProfileUseCase(sl()));
  sl.registerSingleton<GetProgramTemplatesUseCase>(GetProgramTemplatesUseCase(sl()));
  sl.registerSingleton<SaveProgramUseCase>(SaveProgramUseCase(sl()));
  sl.registerSingleton<SetProgramStatusUseCase>(SetProgramStatusUseCase(sl()));
  sl.registerSingleton<AddStaffUseCase>(AddStaffUseCase(sl()));
  sl.registerSingleton<RemoveStaffUseCase>(RemoveStaffUseCase(sl()));
  sl.registerSingleton<GetActivityUseCase>(GetActivityUseCase(sl()));
}
