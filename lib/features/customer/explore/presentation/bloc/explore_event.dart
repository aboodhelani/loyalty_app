abstract class ExploreEvent {
  const ExploreEvent();
}

class LoadExploreEvent extends ExploreEvent {
  const LoadExploreEvent();
}

/// Silent reload after a stamp or a profile change; keeps the current view.
class RefreshExploreEvent extends ExploreEvent {
  const RefreshExploreEvent();
}

class SelectCategoryEvent extends ExploreEvent {
  /// Null clears the filter ("All").
  final String? categoryId;
  const SelectCategoryEvent(this.categoryId);
}

class SearchExploreEvent extends ExploreEvent {
  final String query;
  const SearchExploreEvent(this.query);
}

class ToggleExploreViewEvent extends ExploreEvent {
  const ToggleExploreViewEvent();
}

class SelectBusinessPinEvent extends ExploreEvent {
  /// Null closes the preview card.
  final String? businessId;
  const SelectBusinessPinEvent(this.businessId);
}
