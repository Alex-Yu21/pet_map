import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../domain/revositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  @override
  Future<void> moveCamera(
    YandexMapController controller,
    CameraPosition position,
  ) {
    return controller.moveCamera(CameraUpdate.newCameraPosition(position));
  }
}
