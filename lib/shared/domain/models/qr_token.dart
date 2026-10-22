import 'json_utils.dart';

/// Server-signed, short-lived token behind the customer's QR (spec §8.8).
class QrToken {
  final String token;
  final DateTime expiresAt;

  /// Seconds until the app should fetch a new token.
  final int refreshIn;

  const QrToken({required this.token, required this.expiresAt, required this.refreshIn});

  factory QrToken.fromJson(Json json) {
    final refreshIn = readInt(json['refreshIn'], 30);
    return QrToken(
      token: readString(json['token']),
      expiresAt: readDate(json['expiresAt']) ?? DateTime.now().add(Duration(seconds: refreshIn)),
      refreshIn: refreshIn,
    );
  }
}
