import 'package:dartz/dartz.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../shared/domain/models/transaction.dart';
import '../models/payment_models.dart';

abstract class PaymentRepo {
  Future<Either<Failure, PaymentIntent>> create({required String businessId, required double amount, String? branchId});

  /// Presents Apple Pay (Stripe) or confirms a mock payment. Right(false) when
  /// the customer cancelled.
  Future<Either<Failure, bool>> authorize(PaymentIntent intent, {required String merchantName});

  /// Waits (polling) until the backend has processed the gateway webhook.
  Future<Either<Failure, PaymentTransaction>> awaitResult(String transactionId);
}
