import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/network/error/guard.dart';
import '../../../../shared/domain/models/redemption.dart';
import '../../../../shared/domain/models/scan_result.dart';
import '../../../../shared/domain/models/transaction.dart';
import '../../domain/repositories/staff_repo.dart';
import '../data_sources/remote/staff_api.dart';

class StaffRepoImpl extends StaffRepo {
  final StaffApi api;

  StaffRepoImpl(this.api);

  @override
  Future<Either<Failure, ScanResult>> scan({required String businessId, required String qrToken}) =>
      guardRequest(() => api.scan(businessId: businessId, qrToken: qrToken));

  @override
  Future<Either<Failure, StaffStampResult>> addStamp({required String businessId, required String qrToken}) =>
      guardRequest(() => api.addStamp(businessId: businessId, qrToken: qrToken));

  @override
  Future<Either<Failure, Redemption>> resolveRedemption({required String businessId, required String code}) =>
      guardRequest(() => api.resolveRedemption(businessId: businessId, code: code));

  @override
  Future<Either<Failure, void>> confirmRedemption({required String businessId, required String code}) =>
      guardRequest(() => api.confirmRedemption(businessId: businessId, code: code));

  @override
  Future<Either<Failure, List<PaymentTransaction>>> todaysPayments(String businessId) =>
      guardRequest(() => api.todaysPayments(businessId));
}
