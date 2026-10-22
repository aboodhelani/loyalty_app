import '../../../../../../core/network/api_client.dart';
import '../../../../../../core/utils/constant/network_constant.dart';
import '../../../../../../shared/domain/models/business.dart';
import '../../../../../../shared/domain/models/category.dart';

class ExploreApi {
  final ApiClient _client;

  ExploreApi(this._client);

  /// The MVP has a handful of businesses per area, so one page covers the map;
  /// move to paged loading when real merchant numbers grow.
  static const _pageSize = 100;

  Future<List<Category>> categories() async {
    final list = await _client.getList(categoriesPath);
    return list.whereType<Map>().map((e) => Category.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// Live businesses, sorted by distance when [lat]/[lng] are given. Sent with
  /// the token when signed in so each item carries `myProgress`.
  Future<List<Business>> nearby({double? lat, double? lng}) async {
    final list = await _client.getItems(businessesPath, queryParameters: {
      'pageSize': _pageSize,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    });
    return list.whereType<Map>().map((e) => Business.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<Business> business(String id, {double? lat, double? lng}) async {
    final json = await _client.get(businessPath(id), queryParameters: {
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    });
    return Business.fromJson(json);
  }
}
