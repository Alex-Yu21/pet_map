import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getOnce() async {
    await _ensurePermissions();
    return Geolocator.getCurrentPosition();
  }

  static Stream<Position> stream() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }

  static Future<void> _ensurePermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location disabled');
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever ||
        perm == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
  }
}
