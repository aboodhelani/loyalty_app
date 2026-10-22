import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/router/app_route_enum.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_text_style.dart';
import '../../../../../core/translations/l10n.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/presentation/widgets/state_views.dart';
import '../bloc/explore_bloc.dart';
import '../widgets/business_tile.dart';
import '../widgets/category_chips.dart';
import '../widgets/explore_map_view.dart';
import '../../../../../core/styles/app_icons.dart';
import '../../../../../shared/presentation/widgets/animations.dart';

/// Explore tab: map (C3) and list (C4) of participating businesses. Works
/// without an account.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  void _open(BuildContext context, Business business) {
    Navigator.of(context).pushNamed(AppRouteEnum.businessDetails.name, arguments: business.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state is ExploreError) {
          return SafeArea(
            child: ErrorView(
              message: state.errorMsg,
              onRetry: () => context.read<ExploreBloc>().add(const LoadExploreEvent()),
            ),
          );
        }
        if (state is! ExploreLoaded) return const LoadingView();

        final bloc = context.read<ExploreBloc>();
        final visible = state.visible;
        final selected = state.selected;
        return Stack(
          children: [
            Positioned.fill(
              child: state.view == ExploreView.map
                  ? ExploreMapView(
                      lat: state.lat,
                      lng: state.lng,
                      showUser: state.hasUserLocation,
                      businesses: visible,
                      selectedId: state.selectedBusinessId,
                      onSelect: (id) => bloc.add(SelectBusinessPinEvent(id)),
                      padding: EdgeInsets.only(
                        top: MediaQuery.paddingOf(context).top + 120.h,
                        // Keep the Google logo clear of the preview card.
                        bottom: MediaQuery.paddingOf(context).bottom + (selected == null ? 8.h : 150.h),
                      ),
                    )
                  : _ExploreList(state: state, businesses: visible, onOpen: (b) => _open(context, b)),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _ExploreHeader(state: state),
            ),
            if (state.view == ExploreView.map && selected != null)
              PositionedDirectional(
                start: 16.w,
                end: 16.w,
                // Above the floating nav bar, which the map now runs under.
                bottom: MediaQuery.paddingOf(context).bottom + 12.h,
                child: FadeSlideIn(
                  key: ValueKey(selected.id),
                  from: const Offset(0, 0.3),
                  child: BusinessTile(
                    business: selected,
                    onTap: () => _open(context, selected),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ExploreHeader extends StatelessWidget {
  final ExploreLoaded state;

  const _ExploreHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = context.read<ExploreBloc>();
    final isMap = state.view == ExploreView.map;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background, AppColors.background.withValues(alpha: isMap ? 0 : 1)],
          stops: const [0.75, 1],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.sp),
                        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0, 6))],
                      ),
                      child: TextField(
                        onChanged: (v) => bloc.add(SearchExploreEvent(v)),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: s.searchBusinesses,
                          prefixIcon: const Icon(AppIcons.search),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.sp), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.sp), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.sp),
                            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _ViewToggle(isMap: isMap, onTap: () => bloc.add(const ToggleExploreViewEvent())),
                ],
              ),
            ),
            CategoryChips(
              categories: state.categories,
              selectedId: state.categoryId,
              onSelected: (id) => bloc.add(SelectCategoryEvent(id)),
            ),
            if (!state.hasUserLocation && !isMap)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.w, 10.h, 16.w, 0),
                child: Text(s.demoLocationNotice, style: AppTextStyle.caption),
              ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final bool isMap;
  final VoidCallback onTap;

  const _ViewToggle({required this.isMap, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16.sp),
      elevation: 0,
      shadowColor: AppColors.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.sp),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 13.h),
          child: Row(
            children: [
              Icon(isMap ? AppIcons.list : AppIcons.map, color: AppColors.white, size: 18.sp),
              SizedBox(width: 6.w),
              Text(isMap ? s.listView : s.mapView, style: AppTextStyle.label.copyWith(color: AppColors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreList extends StatelessWidget {
  final ExploreLoaded state;
  final List<Business> businesses;
  final ValueChanged<Business> onOpen;

  const _ExploreList({required this.state, required this.businesses, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    // Clears the floating search + chips (and the location notice when shown).
    final topInset = MediaQuery.paddingOf(context).top + (state.hasUserLocation ? 136.h : 168.h);
    if (businesses.isEmpty) {
      return Padding(
        padding: EdgeInsetsDirectional.only(top: topInset),
        child: EmptyView(
          icon: AppIcons.search,
          title: s.noBusinessesTitle,
          message: s.noBusinessesMessage,
        ),
      );
    }
    return RefreshIndicator(
      edgeOffset: topInset,
      onRefresh: () async => context.read<ExploreBloc>().add(const RefreshExploreEvent()),
      child: ListView.separated(
        padding: EdgeInsetsDirectional.fromSTEB(16.w, topInset, 16.w, MediaQuery.paddingOf(context).bottom + 24.h),
        itemCount: businesses.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, i) {
          final b = businesses[i];
          return FadeSlideIn(index: i, child: BusinessTile(business: b, onTap: () => onOpen(b)));
        },
      ),
    );
  }
}
