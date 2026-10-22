import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_events.dart';
import '../../../../shared/domain/models/loyalty_program.dart';
import '../../domain/models/owner_business.dart';
import '../../domain/usecases/owner_usecases.dart';

abstract class OwnerBusinessState {
  const OwnerBusinessState();
}

class OwnerBusinessLoading extends OwnerBusinessState {}

class OwnerBusinessError extends OwnerBusinessState {
  final String errorMsg;
  const OwnerBusinessError(this.errorMsg);
}

class OwnerBusinessLoaded extends OwnerBusinessState {
  final OwnerBusiness data;
  final bool saving;

  /// One-shot outcome for the page to surface.
  final String? error;
  final String? savedMessageKey;

  const OwnerBusinessLoaded(this.data, {this.saving = false, this.error, this.savedMessageKey});
}

/// What the owner manages for one business: profile (B1), program (B2) and
/// staff (B3). Shared by those three tabs; each write reloads the business.
class OwnerBusinessCubit extends Cubit<OwnerBusinessState> {
  final String businessId;
  final GetOwnerBusinessUseCase getBusinessUseCase;
  final UpdateBusinessProfileUseCase updateProfileUseCase;
  final SaveProgramUseCase saveProgramUseCase;
  final SetProgramStatusUseCase setProgramStatusUseCase;
  final AddStaffUseCase addStaffUseCase;
  final RemoveStaffUseCase removeStaffUseCase;

  OwnerBusinessCubit({
    required this.businessId,
    required this.getBusinessUseCase,
    required this.updateProfileUseCase,
    required this.saveProgramUseCase,
    required this.setProgramStatusUseCase,
    required this.addStaffUseCase,
    required this.removeStaffUseCase,
  }) : super(OwnerBusinessLoading());

  OwnerBusinessLoaded? get _loaded => state is OwnerBusinessLoaded ? state as OwnerBusinessLoaded : null;

  Future<void> load() async {
    if (_loaded == null) emit(OwnerBusinessLoading());
    final result = await getBusinessUseCase(businessId);
    if (isClosed) return;
    result.fold(
      (l) => _loaded == null
          ? emit(OwnerBusinessError(l.errorMessage))
          : emit(OwnerBusinessLoaded(_loaded!.data, error: l.errorMessage)),
      (r) => emit(OwnerBusinessLoaded(r)),
    );
  }

  /// Runs a write, then reloads. [savedKey] tells the page which toast to show.
  Future<bool> _write(Future<dynamic> Function() call, String savedKey) async {
    final current = _loaded;
    if (current == null || current.saving) return false;
    emit(OwnerBusinessLoaded(current.data, saving: true));
    final result = await call();
    if (isClosed) return false;
    return await result.fold((l) async {
      emit(OwnerBusinessLoaded(current.data, error: l.errorMessage));
      return false;
    }, (_) async {
      final fresh = await getBusinessUseCase(businessId);
      if (isClosed) return true;
      emit(OwnerBusinessLoaded(fresh.fold((_) => current.data, (r) => r), savedMessageKey: savedKey));
      AppEvents.notifyBusinessChanged(businessId);
      return true;
    });
  }

  Future<bool> updateProfile(BusinessProfileUpdate update) =>
      _write(() => updateProfileUseCase(UpdateBusinessProfileParams(businessId, update)), 'business');

  Future<bool> saveProgram(LoyaltyProgram program) =>
      _write(() => saveProgramUseCase(SaveProgramParams(businessId, program)), 'program');

  Future<bool> setProgramStatus(ProgramStatus status) =>
      _write(() => setProgramStatusUseCase(SetProgramStatusParams(businessId, status)), 'program');

  Future<bool> addStaff({required String name, required String phone}) => _write(
        () => addStaffUseCase(AddStaffParams(
          businessId: businessId,
          name: name,
          phone: phone,
          branchId: _loaded?.data.business.mainBranch?.id,
        )),
        'staff',
      );

  Future<bool> removeStaff(String staffId) =>
      _write(() => removeStaffUseCase(RemoveStaffParams(businessId, staffId)), 'staffRemoved');
}
