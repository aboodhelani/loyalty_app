import 'package:dartz/dartz.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Runs a data-source call and maps its exceptions to [Failure]s, keeping the
/// API error code so the UI can react to `DAILY_LIMIT_REACHED` and friends.
Future<Either<Failure, T>> guardRequest<T>(Future<T> Function() fn) async {
  try {
    return Right(await fn());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message, e.statusCode, code: e.code, details: e.details));
  } on CancelTokenException catch (e) {
    return Left(CancelTokenFailure(e.message, e.statusCode));
  }
}
