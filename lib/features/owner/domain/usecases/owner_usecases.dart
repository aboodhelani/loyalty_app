import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../../../shared/domain/models/activity_summary.dart';
import '../../../../shared/domain/models/loyalty_program.dart';
import '../models/owner_business.dart';
import '../repositories/owner_repo.dart';

class GetOwnerBusinessUseCase extends UseCase<OwnerBusiness, String> {
  final OwnerRepo repository;

  GetOwnerBusinessUseCase(this.repository);

  @override
  Future<Either<Failure, OwnerBusiness>> call(String businessId) => repository.business(businessId);
}

class UpdateBusinessProfileParams {
  final String businessId;
  final BusinessProfileUpdate update;

  const UpdateBusinessProfileParams(this.businessId, this.update);
}

class UpdateBusinessProfileUseCase extends UseCase<void, UpdateBusinessProfileParams> {
  final OwnerRepo repository;

  UpdateBusinessProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateBusinessProfileParams params) =>
      repository.updateProfile(params.businessId, params.update);
}

class GetProgramTemplatesUseCase extends UseCase<List<ProgramTemplate>, NoParams> {
  final OwnerRepo repository;

  GetProgramTemplatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProgramTemplate>>> call(NoParams params) => repository.templates();
}

class SaveProgramParams {
  final String businessId;
  final LoyaltyProgram program;

  const SaveProgramParams(this.businessId, this.program);
}

class SaveProgramUseCase extends UseCase<LoyaltyProgram, SaveProgramParams> {
  final OwnerRepo repository;

  SaveProgramUseCase(this.repository);

  @override
  Future<Either<Failure, LoyaltyProgram>> call(SaveProgramParams params) =>
      repository.saveProgram(params.businessId, params.program);
}

class SetProgramStatusParams {
  final String businessId;
  final ProgramStatus status;

  const SetProgramStatusParams(this.businessId, this.status);
}

class SetProgramStatusUseCase extends UseCase<void, SetProgramStatusParams> {
  final OwnerRepo repository;

  SetProgramStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SetProgramStatusParams params) =>
      repository.setProgramStatus(params.businessId, params.status);
}

class AddStaffParams {
  final String businessId;
  final String name;
  final String phone;
  final String? branchId;

  const AddStaffParams({required this.businessId, required this.name, required this.phone, this.branchId});
}

class AddStaffUseCase extends UseCase<void, AddStaffParams> {
  final OwnerRepo repository;

  AddStaffUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddStaffParams params) => repository.addStaff(
        params.businessId,
        name: params.name,
        phone: params.phone,
        branchId: params.branchId,
      );
}

class RemoveStaffParams {
  final String businessId;
  final String staffId;

  const RemoveStaffParams(this.businessId, this.staffId);
}

class RemoveStaffUseCase extends UseCase<void, RemoveStaffParams> {
  final OwnerRepo repository;

  RemoveStaffUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveStaffParams params) =>
      repository.removeStaff(params.businessId, params.staffId);
}

class ActivityParams {
  final String businessId;
  final ActivityRange range;

  const ActivityParams(this.businessId, this.range);
}

class GetActivityUseCase extends UseCase<ActivitySummary, ActivityParams> {
  final OwnerRepo repository;

  GetActivityUseCase(this.repository);

  @override
  Future<Either<Failure, ActivitySummary>> call(ActivityParams params) =>
      repository.activity(params.businessId, params.range);
}
