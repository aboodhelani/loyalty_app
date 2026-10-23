import '../../../../../shared/domain/models/json_utils.dart';

/// Response of `POST /payments`. With gateway `stripe` the app presents Apple
/// Pay (iOS) or Google Pay (Android) through flutter_stripe; with gateway `mock` (dev servers) it calls
/// `/payments/:id/mock-confirm` instead.
class PaymentIntent {
  final String transactionId;
  final double amount;
  final String currency;
  final String gateway;
  final bool isMock;
  final String? clientSecret;
  final String? publishableKey;
  final String? merchantIdentifier;
  final String merchantCountryCode;

  const PaymentIntent({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.gateway,
    required this.isMock,
    this.clientSecret,
    this.publishableKey,
    this.merchantIdentifier,
    this.merchantCountryCode = 'AE',
  });

  factory PaymentIntent.fromJson(Json json) {
    final gateway = readString(json['gateway'], json['mock'] == true ? 'mock' : '');
    return PaymentIntent(
      transactionId: readString(json['transactionId']),
      amount: readDouble(json['amount']),
      currency: readString(json['currency'], 'AED'),
      gateway: gateway,
      isMock: json['mock'] == true || gateway == 'mock',
      clientSecret: json['clientSecret']?.toString(),
      publishableKey: json['publishableKey']?.toString(),
      merchantIdentifier: json['merchantIdentifier']?.toString(),
      merchantCountryCode: readString(json['merchantCountryCode'], 'AE'),
    );
  }
}
