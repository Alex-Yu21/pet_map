import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapRepository {
  Future<void> moveCamera(
    GoogleMapController controller,
    CameraPosition position,
  );
}
