/// Exception occur when call api over on time
class CancelTokenException implements Exception {
  final String message;
  final int? statusCode;

  CancelTokenException(this.message, this.statusCode);
}
