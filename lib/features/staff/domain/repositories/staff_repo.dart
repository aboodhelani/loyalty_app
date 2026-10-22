import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../shared/domain/models/redemption.dart';
import '../../../../shared/domain/models/scan_result.dart';
import '../../../../shared/domain/models/transaction.dart';

abstract class StaffRepo {
  Future<Either<Failure, ScanResult>> scan({required String businessId, required String qrToken});

  Future<Either<Failure, StaffStampResult>> addStamp({required String businessId, required String qrToken});

  Future<Either<Failure, Redemption>> resolveRedemption({required String businessId, required String code});

  Future<Either<Failure, void>> confirmRedemption({required String businessId, required String code});

  Future<Either<Failure, List<PaymentTransaction>>> todaysPayments(String businessId);
}
