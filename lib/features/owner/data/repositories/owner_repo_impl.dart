import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/network/error/guard.dart';
import '../../../../shared/domain/models/activity_summary.dart';
import '../../../../shared/domain/models/loyalty_program.dart';
import '../../domain/models/owner_business.dart';
import '../../domain/repositories/owner_repo.dart';
import '../data_sources/remote/owner_api.dart';

class OwnerRepoImpl extends OwnerRepo {
  final OwnerApi api;

  OwnerRepoImpl(this.api);

  @override
  Future<Either<Failure, OwnerBusiness>> business(String id) => guardRequest(() => api.business(id));

  @override
  Future<Either<Failure, void>> updateProfile(String id, BusinessProfileUpdate update) =>
      guardRequest(() => api.updateProfile(id, update));

  @override
  Future<Either<Failure, List<ProgramTemplate>>> templates() => guardRequest(() => api.templates());

  @override
  Future<Either<Failure, LoyaltyProgram>> saveProgram(String id, LoyaltyProgram program) =>
      guardRequest(() => api.saveProgram(id, program));

  @override
  Future<Either<Failure, void>> setProgramStatus(String id, ProgramStatus status) =>
      guardRequest(() => api.setProgramStatus(id, status));

  @override
  Future<Either<Failure, void>> addStaff(String id, {required String name, required String phone, String? branchId}) =>
      guardRequest(() => api.addStaff(id, name: name, phone: phone, branchId: branchId));

  @override
  Future<Either<Failure, void>> removeStaff(String id, String staffId) =>
      guardRequest(() => api.removeStaff(id, staffId));

  @override
  Future<Either<Failure, ActivitySummary>> activity(String id, ActivityRange range) =>
      guardRequest(() => api.activity(id, range));
}
