import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentIntent;

import '../../../domain/models/payment_models.dart';

/// Presents the platform wallet for a Stripe payment intent (spec §9.3):
/// Apple Pay on iOS, Google Pay on Android. Where the wallet is unavailable (no
/// card set up, an emulator without Google Play) it falls back to Stripe's
/// payment sheet, which still offers the wallet plus test cards.
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

    // Google Pay must use its test environment with Stripe test keys.
    final testEnv = key.startsWith('pk_test_');

    try {
      if (Platform.isAndroid) {
        await _googlePay(intent, secret, merchantName, testEnv);
      } else {
        await _applePay(intent, secret, merchantName, testEnv);
      }
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return false;
      rethrow;
    }
  }

  Future<void> _applePay(PaymentIntent intent, String secret, String merchantName, bool testEnv) async {
    if (!await Stripe.instance.isPlatformPaySupported()) {
      return _paymentSheet(intent, secret, merchantName, testEnv);
    }
    await Stripe.instance.confirmPlatformPayPaymentIntent(
      clientSecret: secret,
      confirmParams: PlatformPayConfirmParams.applePay(
        applePay: ApplePayParams(
          merchantCountryCode: intent.merchantCountryCode,
          currencyCode: intent.currency,
          cartItems: [
            ApplePayCartSummaryItem.immediate(label: merchantName, amount: intent.amount.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  Future<void> _googlePay(PaymentIntent intent, String secret, String merchantName, bool testEnv) async {
    final supported = await Stripe.instance.isPlatformPaySupported(
      googlePay: IsGooglePaySupportedParams(testEnv: testEnv),
    );
    if (!supported) return _paymentSheet(intent, secret, merchantName, testEnv);
    await Stripe.instance.confirmPlatformPayPaymentIntent(
      clientSecret: secret,
      confirmParams: PlatformPayConfirmParams.googlePay(
        googlePay: GooglePayParams(
          testEnv: testEnv,
          merchantCountryCode: intent.merchantCountryCode,
          currencyCode: intent.currency,
          merchantName: merchantName,
          // Minor units (fils), as Google Pay expects.
          amount: (intent.amount * 100).round(),
        ),
      ),
    );
  }

  Future<void> _paymentSheet(PaymentIntent intent, String secret, String merchantName, bool testEnv) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: secret,
        merchantDisplayName: merchantName,
        applePay: PaymentSheetApplePay(merchantCountryCode: intent.merchantCountryCode),
        googlePay: PaymentSheetGooglePay(
          merchantCountryCode: intent.merchantCountryCode,
          currencyCode: intent.currency,
          testEnv: testEnv,
        ),
        style: ThemeMode.light,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }
}
