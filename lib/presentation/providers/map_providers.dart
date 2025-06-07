import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_map/data/map_repository_impl.dart';
import 'package:pet_map/data/services/location_service.dart';
import 'package:pet_map/domain/map_repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

final mapRepoProvider = Provider<MapRepository>((_) => MapRepositoryImpl());

final mapCtrlProvider = StateProvider<YandexMapController?>((_) => null);

final currentPosProvider = FutureProvider.autoDispose<Position>((_) async {
  return LocationService.getOnce();
});

final posStreamProvider = StreamProvider.autoDispose<Position>((_) {
  return LocationService.stream();
});
