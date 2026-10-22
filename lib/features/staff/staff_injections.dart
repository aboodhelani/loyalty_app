import '../../core/network/dio_network.dart';
import '../../core/utils/injections.dart';
import 'data/data_sources/remote/staff_api.dart';
import 'data/repositories/staff_repo_impl.dart';
import 'domain/repositories/staff_repo.dart';
import 'domain/usecases/staff_usecases.dart';

initStaffInjections() {
  sl.registerSingleton<StaffApi>(StaffApi(DioNetwork.apiClient));
  sl.registerSingleton<StaffRepo>(StaffRepoImpl(sl()));
  sl.registerSingleton<ScanCustomerUseCase>(ScanCustomerUseCase(sl()));
  sl.registerSingleton<AddStampUseCase>(AddStampUseCase(sl()));
  sl.registerSingleton<ResolveRedemptionUseCase>(ResolveRedemptionUseCase(sl()));
  sl.registerSingleton<ConfirmRedemptionUseCase>(ConfirmRedemptionUseCase(sl()));
  sl.registerSingleton<GetTodaysPaymentsUseCase>(GetTodaysPaymentsUseCase(sl()));
}
