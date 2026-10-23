import 'package:dartz/dartz.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../core/utils/usecases/usecase.dart';
import '../../../../../shared/domain/models/transaction.dart';
import '../models/payment_models.dart';
import '../repositories/payment_repo.dart';

class CreatePaymentParams {
  final String businessId;
  final double amount;
  final String? branchId;

  const CreatePaymentParams({required this.businessId, required this.amount, this.branchId});
}

class CreatePaymentUseCase extends UseCase<PaymentIntent, CreatePaymentParams> {
  final PaymentRepo repository;

  CreatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentIntent>> call(CreatePaymentParams params) =>
      repository.create(businessId: params.businessId, amount: params.amount, branchId: params.branchId);
}

class AuthorizePaymentParams {
  final PaymentIntent intent;
  final String merchantName;

  const AuthorizePaymentParams(this.intent, this.merchantName);
}

/// Wallet sheet (Apple Pay / Google Pay). Right(false) when the customer cancels.
class AuthorizePaymentUseCase extends UseCase<bool, AuthorizePaymentParams> {
  final PaymentRepo repository;

  AuthorizePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(AuthorizePaymentParams params) =>
      repository.authorize(params.intent, merchantName: params.merchantName);
}

class AwaitPaymentResultUseCase extends UseCase<PaymentTransaction, String> {
  final PaymentRepo repository;

  AwaitPaymentResultUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentTransaction>> call(String transactionId) => repository.awaitResult(transactionId);
}
