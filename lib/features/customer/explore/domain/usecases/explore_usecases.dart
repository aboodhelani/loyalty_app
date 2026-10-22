import 'package:dartz/dartz.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../core/utils/usecases/usecase.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/domain/models/category.dart';
import '../repositories/explore_repo.dart';

class GetCategoriesUseCase extends UseCase<List<Category>, NoParams> {
  final ExploreRepo repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) => repository.categories();
}

class LocationParams {
  final double? lat;
  final double? lng;

  const LocationParams({this.lat, this.lng});
}

class GetNearbyBusinessesUseCase extends UseCase<List<Business>, LocationParams> {
  final ExploreRepo repository;

  GetNearbyBusinessesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Business>>> call(LocationParams params) =>
      repository.nearby(lat: params.lat, lng: params.lng);
}

class GetBusinessParams {
  final String id;
  final double? lat;
  final double? lng;

  const GetBusinessParams(this.id, {this.lat, this.lng});
}

class GetBusinessUseCase extends UseCase<Business, GetBusinessParams> {
  final ExploreRepo repository;

  GetBusinessUseCase(this.repository);

  @override
  Future<Either<Failure, Business>> call(GetBusinessParams params) =>
      repository.business(params.id, lat: params.lat, lng: params.lng);
}
