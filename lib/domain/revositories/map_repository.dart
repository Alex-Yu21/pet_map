import 'package:yandex_mapkit/yandex_mapkit.dart';

abstract class MapRepository {
  Future<void> moveCamera(
    YandexMapController controller,
    CameraPosition position,
  );
}
