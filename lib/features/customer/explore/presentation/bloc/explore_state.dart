import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/domain/models/category.dart';

enum ExploreView { map, list }

abstract class ExploreState {
  const ExploreState();
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreError extends ExploreState {
  final String errorMsg;
  const ExploreError(this.errorMsg);
}

class ExploreLoaded extends ExploreState {
  final List<Category> categories;

  /// Everything nearby, sorted by distance; filters apply on top.
  final List<Business> businesses;
  final String? categoryId;
  final String query;
  final ExploreView view;
  final String? selectedBusinessId;
  final double lat;
  final double lng;

  /// Location permission granted: the map shows the live blue dot. When false
  /// we centre on the demo area instead.
  final bool hasUserLocation;

  const ExploreLoaded({
    required this.categories,
    required this.businesses,
    this.categoryId,
    this.query = '',
    this.view = ExploreView.map,
    this.selectedBusinessId,
    required this.lat,
    required this.lng,
    required this.hasUserLocation,
  });

  List<Business> get visible {
    final q = query.trim().toLowerCase();
    return businesses
        .where((b) => categoryId == null || b.categoryId == categoryId)
        .where((b) => q.isEmpty || b.name.toLowerCase().contains(q))
        .toList();
  }

  Business? get selected {
    for (final b in businesses) {
      if (b.id == selectedBusinessId) return b;
    }
    return null;
  }

  ExploreLoaded copyWith({
    List<Business>? businesses,
    String? categoryId,
    bool clearCategory = false,
    String? query,
    ExploreView? view,
    String? selectedBusinessId,
    bool clearSelection = false,
  }) {
    return ExploreLoaded(
      categories: categories,
      businesses: businesses ?? this.businesses,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      query: query ?? this.query,
      view: view ?? this.view,
      selectedBusinessId: clearSelection ? null : (selectedBusinessId ?? this.selectedBusinessId),
      lat: lat,
      lng: lng,
      hasUserLocation: hasUserLocation,
    );
  }
}
