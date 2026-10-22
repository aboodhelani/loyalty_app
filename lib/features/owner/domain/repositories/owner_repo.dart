import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../shared/domain/models/activity_summary.dart';
import '../../../../shared/domain/models/loyalty_program.dart';
import '../models/owner_business.dart';

abstract class OwnerRepo {
  Future<Either<Failure, OwnerBusiness>> business(String id);

  Future<Either<Failure, void>> updateProfile(String id, BusinessProfileUpdate update);

  Future<Either<Failure, List<ProgramTemplate>>> templates();

  Future<Either<Failure, LoyaltyProgram>> saveProgram(String id, LoyaltyProgram program);

  Future<Either<Failure, void>> setProgramStatus(String id, ProgramStatus status);

  Future<Either<Failure, void>> addStaff(String id, {required String name, required String phone, String? branchId});

  Future<Either<Failure, void>> removeStaff(String id, String staffId);

  Future<Either<Failure, ActivitySummary>> activity(String id, ActivityRange range);
}
