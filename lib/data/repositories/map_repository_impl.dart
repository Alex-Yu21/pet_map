import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  @override
  Future<void> moveCamera(
    GoogleMapController controller,
    CameraPosition position,
  ) {
    return controller.moveCamera(CameraUpdate.newCameraPosition(position));
  }
}
