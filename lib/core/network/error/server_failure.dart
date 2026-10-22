import 'failure.dart';

/// General failures
class ServerFailure extends Failure {
  final int? statusCode;

  /// The API's error code — see [ServerException.code].
  final String? code;
  final dynamic details;

  const ServerFailure(super.errorMessage, this.statusCode, {this.code, this.details});
}
