import 'json_utils.dart';

/// A one-time code the customer shows and staff confirm (C11 / S2). Valid for
/// 15 minutes.
class Redemption {
  final String id;
  final String code;

  /// What the QR encodes; falls back to the code so staff can scan either.
  final String qrPayload;
  final String rewardText;
  final String? businessName;
  final String? customerFirstName;
  final DateTime? expiresAt;
  final DateTime? redeemedAt;

  const Redemption({
    required this.id,
    required this.code,
    required this.qrPayload,
    required this.rewardText,
    this.businessName,
    this.customerFirstName,
    this.expiresAt,
    this.redeemedAt,
  });

  bool get isConfirmed => redeemedAt != null;

  factory Redemption.fromJson(Json json) {
    final code = readString(json['code']);
    final card = readMap(json['card']) ?? readMap(json['stampCard']);
    final business = readMap(json['business']) ?? readMap(card?['business']);
    final customer = readMap(json['customer']);
    return Redemption(
      id: readString(json['id'], readString(json['redemptionId'])),
      code: code,
      qrPayload: readString(json['qrPayload'], readString(json['qr'], code)),
      rewardText: readString(json['rewardText'], readString(card?['rewardText'])),
      businessName: business?['name']?.toString(),
      customerFirstName: customer?['firstName']?.toString(),
      expiresAt: readDate(json['expiresAt']),
      redeemedAt: readDate(json['redeemedAt']),
    );
  }
}
