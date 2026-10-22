import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_icons.dart';
import '../../../../../core/utils/injections.dart';
import '../../../../../core/utils/location_service.dart';
import '../../../../../shared/presentation/widgets/pressable.dart';

import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/presentation/widgets/category_style.dart';
import 'map_pin_factory.dart';
import 'map_style.dart';

/// The only file that knows the map SDK (Google Maps, spec §2).
class ExploreMapView extends StatefulWidget {
  final double lat;
  final double lng;
  final bool showUser;
  final List<Business> businesses;
  final String? selectedId;
  final ValueChanged<String?> onSelect;

  /// Space covered by the floating header and nav, so the Google logo and the
  /// camera centre stay in the visible area.
  final EdgeInsets padding;

  const ExploreMapView({
    super.key,
    required this.lat,
    required this.lng,
    required this.showUser,
    required this.businesses,
    required this.selectedId,
    required this.onSelect,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<ExploreMapView> createState() => _ExploreMapViewState();
}

class _ExploreMapViewState extends State<ExploreMapView> {
  GoogleMapController? _controller;
  Set<Marker> _markers = const {};
  int _buildToken = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildMarkers();
  }

  @override
  void didUpdateWidget(ExploreMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.businesses != widget.businesses || oldWidget.selectedId != widget.selectedId) {
      _buildMarkers();
    }
    if (widget.selectedId != null && widget.selectedId != oldWidget.selectedId) {
      final branch = widget.businesses.where((b) => b.id == widget.selectedId).firstOrNull?.mainBranch;
      if (branch != null) _controller?.animateCamera(CameraUpdate.newLatLng(LatLng(branch.lat, branch.lng)));
    }
  }

  Future<void> _buildMarkers() async {
    final token = ++_buildToken;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final markers = <Marker>{};
    for (final b in widget.businesses) {
      final branch = b.mainBranch;
      if (branch == null) continue;
      final selected = b.id == widget.selectedId;
      final icon = await MapPinFactory.pin(
        CategoryStyle.of(b.category?.slug),
        selected: selected,
        hasReward: b.myProgress?.isReady ?? false,
        devicePixelRatio: dpr,
      );
      markers.add(Marker(
        markerId: MarkerId(b.id),
        position: LatLng(branch.lat, branch.lng),
        icon: icon,
        anchor: const Offset(0.5, 1),
        zIndexInt: selected ? 2 : 1,
        consumeTapEvents: true,
        onTap: () => widget.onSelect(b.id),
      ));
    }
    if (mounted && token == _buildToken) setState(() => _markers = markers);
  }

  Future<void> _locateMe() async {
    final position = await sl<LocationService>().current();
    if (position == null || !mounted) return;
    await _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 15.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _map()),
        if (widget.showUser)
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            end: 16.w,
            bottom: widget.padding.bottom + 12.h,
            child: _LocateButton(onTap: _locateMe),
          ),
      ],
    );
  }

  Widget _map() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(widget.lat, widget.lng), zoom: 14),
      style: warmMapStyle,
      markers: _markers,
      padding: widget.padding,
      // Google's live blue dot, updated by the SDK as the user moves.
      myLocationEnabled: widget.showUser,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      onMapCreated: (c) => _controller = c,
      onTap: (_) => widget.onSelect(null),
    );
  }
}

class _LocateButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LocateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      child: Material(
        color: AppColors.surfaceElevated,
        shape: const CircleBorder(),
        elevation: 0,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: 48.sp,
            height: 48.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 14, offset: const Offset(0, 4))],
            ),
            child: Icon(AppIcons.crosshair, color: AppColors.primary, size: 22.sp),
          ),
        ),
      ),
    );
  }
}
