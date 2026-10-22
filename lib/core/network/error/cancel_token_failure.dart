import 'failure.dart';

/// Cancel token failure
class CancelTokenFailure extends Failure {
  final int? statusCode;

  const CancelTokenFailure(super.errorMessage, this.statusCode);
}
