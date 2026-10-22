import 'package:dartz/dartz.dart';

import '../../../../../core/network/error/guard.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/domain/models/category.dart';
import '../../domain/repositories/explore_repo.dart';
import '../data_sources/remote/explore_api.dart';

class ExploreRepoImpl extends ExploreRepo {
  final ExploreApi api;

  ExploreRepoImpl(this.api);

  @override
  Future<Either<Failure, List<Category>>> categories() => guardRequest(() => api.categories());

  @override
  Future<Either<Failure, List<Business>>> nearby({double? lat, double? lng}) =>
      guardRequest(() => api.nearby(lat: lat, lng: lng));

  @override
  Future<Either<Failure, Business>> business(String id, {double? lat, double? lng}) =>
      guardRequest(() => api.business(id, lat: lat, lng: lng));
}
