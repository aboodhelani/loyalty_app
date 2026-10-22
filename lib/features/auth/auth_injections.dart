import '../../core/network/dio_network.dart';
import '../../core/utils/injections.dart';
import 'data/data_sources/remote/auth_api.dart';
import 'data/repositories/auth_repo_impl.dart';
import 'domain/repositories/auth_repo.dart';
import 'domain/usecases/auth_usecases.dart';

initAuthInjections() {
  sl.registerSingleton<AuthApi>(AuthApi(DioNetwork.apiClient));
  sl.registerSingleton<AuthRepo>(AuthRepoImpl(sl(), sl()));
  sl.registerSingleton<RequestOtpUseCase>(RequestOtpUseCase(sl()));
  sl.registerSingleton<VerifyOtpUseCase>(VerifyOtpUseCase(sl()));
  sl.registerSingleton<UpdateProfileUseCase>(UpdateProfileUseCase(sl()));
  sl.registerSingleton<GetMeUseCase>(GetMeUseCase(sl()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl()));
}
