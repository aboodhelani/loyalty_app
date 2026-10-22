import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentIntent;

import '../../../../../core/network/error/exceptions.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/error/guard.dart';
import '../../../../../shared/domain/models/transaction.dart';
import '../../domain/models/payment_models.dart';
import '../../domain/repositories/payment_repo.dart';
import '../data_sources/remote/payment_api.dart';
import '../data_sources/remote/wallet_pay_service.dart';

class PaymentRepoImpl extends PaymentRepo {
  final PaymentApi api;
  final WalletPayService wallet;

  PaymentRepoImpl(this.api, this.wallet);

  static const _pollInterval = Duration(seconds: 1);
  static const _pollAttempts = 30;

  @override
  Future<Either<Failure, PaymentIntent>> create(
          {required String businessId, required double amount, String? branchId}) =>
      guardRequest(() => api.create(businessId: businessId, amount: amount, branchId: branchId));

  @override
  Future<Either<Failure, bool>> authorize(PaymentIntent intent, {required String merchantName}) {
    return guardRequest(() async {
      if (intent.isMock) {
        await api.mockConfirm(intent.transactionId);
        return true;
      }
      try {
        return await wallet.pay(intent, merchantName: merchantName);
      } on StripeException catch (e) {
        throw ServerException(e.error.localizedMessage ?? e.error.message ?? 'Payment failed', null);
      } on StateError catch (e) {
        throw ServerException(e.message, null);
      }
    });
  }

  @override
  Future<Either<Failure, PaymentTransaction>> awaitResult(String transactionId) {
    return guardRequest(() async {
      PaymentTransaction? last;
      for (var i = 0; i < _pollAttempts; i++) {
        last = await api.result(transactionId);
        // Settled, and for a success the stamp outcome is in too.
        if (last.isSettled && (last.status != TransactionStatus.succeeded || last.stampOutcomeRaw != null)) {
          return last;
        }
        await Future.delayed(_pollInterval);
      }
      if (last != null && last.isSettled) return last;
      throw ServerException('The payment is taking longer than usual. Check your wallet in a moment.', null);
    });
  }
}
