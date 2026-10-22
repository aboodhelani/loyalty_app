import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../../../shared/domain/models/redemption.dart';
import '../../../../shared/domain/models/scan_result.dart';
import '../../../../shared/domain/models/transaction.dart';
import '../repositories/staff_repo.dart';

class StaffScanParams {
  final String businessId;
  final String value;

  const StaffScanParams({required this.businessId, required this.value});
}

class ScanCustomerUseCase extends UseCase<ScanResult, StaffScanParams> {
  final StaffRepo repository;

  ScanCustomerUseCase(this.repository);

  @override
  Future<Either<Failure, ScanResult>> call(StaffScanParams params) =>
      repository.scan(businessId: params.businessId, qrToken: params.value);
}

class AddStampUseCase extends UseCase<StaffStampResult, StaffScanParams> {
  final StaffRepo repository;

  AddStampUseCase(this.repository);

  @override
  Future<Either<Failure, StaffStampResult>> call(StaffScanParams params) =>
      repository.addStamp(businessId: params.businessId, qrToken: params.value);
}

class ResolveRedemptionUseCase extends UseCase<Redemption, StaffScanParams> {
  final StaffRepo repository;

  ResolveRedemptionUseCase(this.repository);

  @override
  Future<Either<Failure, Redemption>> call(StaffScanParams params) =>
      repository.resolveRedemption(businessId: params.businessId, code: params.value);
}

class ConfirmRedemptionUseCase extends UseCase<void, StaffScanParams> {
  final StaffRepo repository;

  ConfirmRedemptionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(StaffScanParams params) =>
      repository.confirmRedemption(businessId: params.businessId, code: params.value);
}

class GetTodaysPaymentsUseCase extends UseCase<List<PaymentTransaction>, String> {
  final StaffRepo repository;

  GetTodaysPaymentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentTransaction>>> call(String businessId) => repository.todaysPayments(businessId);
}
