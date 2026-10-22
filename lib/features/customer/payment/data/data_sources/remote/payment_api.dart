import '../../../../../../core/network/api_client.dart';
import '../../../../../../core/utils/constant/network_constant.dart';
import '../../../../../../shared/domain/models/transaction.dart';
import '../../../domain/models/payment_models.dart';

class PaymentApi {
  final ApiClient _client;

  PaymentApi(this._client);

  Future<PaymentIntent> create({required String businessId, required double amount, String? branchId}) async {
    final json = await _client.post(paymentsPath, data: {
      'businessId': businessId,
      'amount': amount,
      if (branchId != null) 'branchId': branchId,
    });
    return PaymentIntent.fromJson(json);
  }

  /// Dev/demo only: simulates the gateway webhook on a `mock` gateway.
  Future<void> mockConfirm(String transactionId) async {
    await _client.post(paymentMockConfirmPath(transactionId), data: {});
  }

  /// Payment result, including the stamp outcome once the webhook ran.
  Future<PaymentTransaction> result(String transactionId) async {
    final json = await _client.get(paymentPath(transactionId));
    return PaymentTransaction.fromJson(json);
  }
}
