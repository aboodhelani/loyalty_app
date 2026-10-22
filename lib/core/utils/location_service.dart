import 'package:geolocator/geolocator.dart';

/// Wraps location permission and lookup. Every failure resolves to null so the
/// map falls back to the demo area instead of erroring.
class LocationService {
  /// iOS allows one permission prompt at a time; concurrent callers (the
  /// onboarding button and the Explore load) share the same request.
  Future<bool>? _inFlight;

  Future<bool> requestPermission() {
    return _inFlight ??= _request().whenComplete(() => _inFlight = null);
  }

  Future<bool> _request() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return false;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }

  Future<Position?> current() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) return null;
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 8)),
      );
    } catch (_) {
      return null;
    }
  }
}
