import 'dart:async';

/// A loyalty notification shown in-app (spec §8 "Notifications (MVP)"),
/// delivered over the socket's `notification` event. Push (FCM) comes later.
class AppNotice {
  final String title;
  final String body;

  const AppNotice(this.title, this.body);
}

/// App-wide signals that cut across features.
class AppEvents {
  const AppEvents._();

  static final _walletChanged = StreamController<void>.broadcast();
  static final _businessChanged = StreamController<String?>.broadcast();
  static final _paymentReceived = StreamController<String>.broadcast();
  static final _notices = StreamController<AppNotice>.broadcast();
  static final _sessionExpired = StreamController<void>.broadcast();

  /// A stamp was added or a reward redeemed — wallet and map progress reload.
  static Stream<void> get walletChanged => _walletChanged.stream;

  /// A business profile or program changed (owner edits, admin approval).
  static Stream<String?> get businessChanged => _businessChanged.stream;

  /// A payment landed at the given business id (feeds S3 without polling).
  static Stream<String> get paymentReceived => _paymentReceived.stream;

  static Stream<AppNotice> get notices => _notices.stream;

  /// The refresh token was rejected; the session drops to guest mode.
  static Stream<void> get sessionExpired => _sessionExpired.stream;

  static void notifyWalletChanged() => _walletChanged.add(null);

  static void notifyBusinessChanged([String? businessId]) => _businessChanged.add(businessId);

  static void notifyPaymentReceived(String businessId) => _paymentReceived.add(businessId);

  static void notify(AppNotice notice) => _notices.add(notice);

  static void notifySessionExpired() => _sessionExpired.add(null);
}
