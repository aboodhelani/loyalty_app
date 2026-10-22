/// Exception occur when server failure
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  /// The API's machine-readable error (`DAILY_LIMIT_REACHED`, `CARD_NOT_READY`…).
  /// Switch on this, not on [message].
  final String? code;

  /// Extra context from the API error body, e.g. `nextAvailableAt`.
  final dynamic details;

  ServerException(this.message, this.statusCode, {this.code, this.details});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (other is ServerException) {
      return other.message == message && other.statusCode == statusCode && other.code == code;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(message, statusCode, code);
}
