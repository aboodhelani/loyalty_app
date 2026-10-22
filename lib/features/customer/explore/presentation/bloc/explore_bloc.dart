import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../../core/utils/app_events.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../../core/utils/location_service.dart';
import '../../../../../core/utils/usecases/usecase.dart';
import '../../domain/usecases/explore_usecases.dart';
import 'explore_event.dart';
import 'explore_state.dart';

export 'explore_event.dart';
export 'explore_state.dart';

/// Map + list discovery (C3 / C4).
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetNearbyBusinessesUseCase getNearbyBusinessesUseCase;
  final LocationService locationService;

  StreamSubscription<void>? _walletSub;
  StreamSubscription<String?>? _businessSub;

  ExploreBloc({
    required this.getCategoriesUseCase,
    required this.getNearbyBusinessesUseCase,
    required this.locationService,
  }) : super(ExploreInitial()) {
    on<LoadExploreEvent>(_onLoad);
    on<RefreshExploreEvent>(_onRefresh);
    on<SelectCategoryEvent>(_onCategory);
    on<SearchExploreEvent>(_onSearch);
    on<ToggleExploreViewEvent>(_onToggle);
    on<SelectBusinessPinEvent>(_onSelectPin);

    // Progress on the preview card must follow new stamps and redemptions.
    _walletSub = AppEvents.walletChanged.listen((_) => add(const RefreshExploreEvent()));
    _businessSub = AppEvents.businessChanged.listen((_) => add(const RefreshExploreEvent()));
  }

  ExploreLoaded? get _loaded => state is ExploreLoaded ? state as ExploreLoaded : null;

  Future<void> _onLoad(LoadExploreEvent event, Emitter<ExploreState> emitter) async {
    emitter(ExploreLoading());
    // Ask once if never decided; the map then shows the live blue dot.
    final granted = await locationService.requestPermission();
    final position = granted ? await locationService.current() : null;
    final lat = position?.latitude ?? defaultLat;
    final lng = position?.longitude ?? defaultLng;

    final categories = await getCategoriesUseCase(NoParams());
    final businesses = await getNearbyBusinessesUseCase(LocationParams(lat: lat, lng: lng));
    if (categories.isLeft() || businesses.isLeft()) {
      final failure = categories.fold((l) => l, (_) => null) ?? businesses.fold((l) => l, (_) => null);
      emitter(ExploreError(failure!.errorMessage));
      return;
    }
    emitter(ExploreLoaded(
      categories: categories.getOrElse(() => []),
      businesses: businesses.getOrElse(() => []),
      lat: lat,
      lng: lng,
      hasUserLocation: granted,
    ));
  }

  Future<void> _onRefresh(RefreshExploreEvent event, Emitter<ExploreState> emitter) async {
    final current = _loaded;
    if (current == null) return;
    final result = await getNearbyBusinessesUseCase(LocationParams(lat: current.lat, lng: current.lng));
    // A failed background refresh keeps what is on screen.
    result.fold((_) {}, (r) => emitter((_loaded ?? current).copyWith(businesses: r)));
  }

  void _onCategory(SelectCategoryEvent event, Emitter<ExploreState> emitter) {
    final current = _loaded;
    if (current == null) return;
    emitter(current.copyWith(
      categoryId: event.categoryId,
      clearCategory: event.categoryId == null,
      clearSelection: true,
    ));
  }

  void _onSearch(SearchExploreEvent event, Emitter<ExploreState> emitter) {
    final current = _loaded;
    if (current == null) return;
    emitter(current.copyWith(query: event.query, clearSelection: true));
  }

  void _onToggle(ToggleExploreViewEvent event, Emitter<ExploreState> emitter) {
    final current = _loaded;
    if (current == null) return;
    emitter(current.copyWith(
      view: current.view == ExploreView.map ? ExploreView.list : ExploreView.map,
      clearSelection: true,
    ));
  }

  void _onSelectPin(SelectBusinessPinEvent event, Emitter<ExploreState> emitter) {
    final current = _loaded;
    if (current == null) return;
    emitter(current.copyWith(selectedBusinessId: event.businessId, clearSelection: event.businessId == null));
  }

  @override
  Future<void> close() {
    _walletSub?.cancel();
    _businessSub?.cancel();
    return super.close();
  }
}
