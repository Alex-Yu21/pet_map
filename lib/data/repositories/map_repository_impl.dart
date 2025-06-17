import 'package:pet_map/domain/repositories/map_repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapRepositoryImpl implements MapRepository {
  @override
  Future<void> moveCamera(
    YandexMapController controller,
    CameraPosition position,
  ) {
    return controller.moveCamera(CameraUpdate.newCameraPosition(position));
  }
}
