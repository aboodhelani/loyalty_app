import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentIntent;

import '../../../domain/models/payment_models.dart';

/// Presents Apple Pay for a Stripe payment intent (spec §9.3). Falls back to
/// Stripe's payment sheet where Apple Pay is unavailable (Android, or a
/// simulator without a wallet card), so the flow can still be tested with
/// Stripe test cards.
///
/// Returns false when the user dismisses the sheet. The stamp is never decided
/// here — the backend issues it from Stripe's webhook.
class WalletPayService {
  Future<bool> pay(PaymentIntent intent, {required String merchantName}) async {
    final secret = intent.clientSecret;
    final key = intent.publishableKey;
    if (secret == null || key == null) {
      throw StateError('Payment intent is missing Stripe keys');
    }
    Stripe.publishableKey = key;
    if (intent.merchantIdentifier != null) Stripe.merchantIdentifier = intent.merchantIdentifier;
    await Stripe.instance.applySettings();

    try {
      if (await Stripe.instance.isPlatformPaySupported()) {
        await Stripe.instance.confirmPlatformPayPaymentIntent(
          clientSecret: secret,
          confirmParams: PlatformPayConfirmParams.applePay(
            applePay: ApplePayParams(
              merchantCountryCode: intent.merchantCountryCode,
              currencyCode: intent.currency,
              cartItems: [
                ApplePayCartSummaryItem.immediate(
                  label: merchantName,
                  amount: intent.amount.toStringAsFixed(2),
                ),
              ],
            ),
          ),
        );
      } else {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: secret,
            merchantDisplayName: merchantName,
            applePay: PaymentSheetApplePay(merchantCountryCode: intent.merchantCountryCode),
            style: ThemeMode.light,
          ),
        );
        await Stripe.instance.presentPaymentSheet();
      }
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return false;
      rethrow;
    }
  }
}
