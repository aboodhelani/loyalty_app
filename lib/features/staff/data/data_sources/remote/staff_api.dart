import '../../../../../core/network/api_client.dart';
import '../../../../../core/utils/constant/network_constant.dart';
import '../../../../../shared/domain/models/redemption.dart';
import '../../../../../shared/domain/models/scan_result.dart';
import '../../../../../shared/domain/models/transaction.dart';

/// Business app, staff side (S1–S3). Every call names the business, since an
/// owner of several businesses can also work the counter.
class StaffApi {
  final ApiClient _client;

  StaffApi(this._client);

  /// S1 step 1 — decode the customer QR.
  Future<ScanResult> scan({required String businessId, required String qrToken}) async {
    final json = await _client.post(staffScanPath, data: {'qrToken': qrToken, 'businessId': businessId});
    return ScanResult.fromJson(json);
  }

  /// S1 step 2 — "Add stamp". The server re-verifies the QR.
  Future<StaffStampResult> addStamp({required String businessId, required String qrToken}) async {
    final json = await _client.post(staffStampsPath, data: {'qrToken': qrToken, 'businessId': businessId});
    return StaffStampResult.fromJson(json);
  }

  /// S2 step 1 — scanned or typed redemption code → the reward.
  Future<Redemption> resolveRedemption({required String businessId, required String code}) async {
    final json = await _client.post(staffRedemptionResolvePath, data: {'code': code, 'businessId': businessId});
    return Redemption.fromJson(json);
  }

  /// S2 step 2 — reward handed over; the card resets to 0.
  Future<void> confirmRedemption({required String businessId, required String code}) async {
    await _client.post(staffRedemptionConfirmPath, data: {'code': code, 'businessId': businessId});
  }

  /// S3 — today's successful in-app payments.
  Future<List<PaymentTransaction>> todaysPayments(String businessId) async {
    final list = await _client.getList(staffPaymentsPath, queryParameters: {'businessId': businessId});
    return list.whereType<Map>().map((e) => PaymentTransaction.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
