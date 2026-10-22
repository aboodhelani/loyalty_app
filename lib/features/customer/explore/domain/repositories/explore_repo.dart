import 'package:dartz/dartz.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/domain/models/category.dart';

abstract class ExploreRepo {
  Future<Either<Failure, List<Category>>> categories();

  Future<Either<Failure, List<Business>>> nearby({double? lat, double? lng});

  Future<Either<Failure, Business>> business(String id, {double? lat, double? lng});
}
