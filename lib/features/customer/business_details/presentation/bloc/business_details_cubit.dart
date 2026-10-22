import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_events.dart';
import '../../../../../core/utils/location_service.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../explore/domain/usecases/explore_usecases.dart';

abstract class BusinessDetailsState {
  const BusinessDetailsState();
}

class BusinessDetailsLoading extends BusinessDetailsState {}

class BusinessDetailsError extends BusinessDetailsState {
  final String errorMsg;
  const BusinessDetailsError(this.errorMsg);
}

class BusinessDetailsLoaded extends BusinessDetailsState {
  final Business business;
  const BusinessDetailsLoaded(this.business);
}

/// Business profile (C5).
class BusinessDetailsCubit extends Cubit<BusinessDetailsState> {
  final String businessId;
  final GetBusinessUseCase getBusinessUseCase;
  final LocationService locationService;
  StreamSubscription<void>? _walletSub;

  BusinessDetailsCubit({
    required this.businessId,
    required this.getBusinessUseCase,
    required this.locationService,
  }) : super(BusinessDetailsLoading()) {
    _walletSub = AppEvents.walletChanged.listen((_) => load(silent: true));
  }

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(BusinessDetailsLoading());
    final position = await locationService.current();
    final result = await getBusinessUseCase(
      GetBusinessParams(businessId, lat: position?.latitude, lng: position?.longitude),
    );
    if (isClosed) return;
    result.fold(
      (l) => silent ? null : emit(BusinessDetailsError(l.errorMessage)),
      (business) => emit(BusinessDetailsLoaded(business)),
    );
  }

  @override
  Future<void> close() {
    _walletSub?.cancel();
    return super.close();
  }
}
