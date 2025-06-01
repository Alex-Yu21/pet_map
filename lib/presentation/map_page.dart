import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../data/map_repository_impl.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _repo = MapRepositoryImpl();
  final _initialPosition = const CameraPosition(
    target: Point(latitude: 59.9343, longitude: 30.3351),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        zoomGesturesEnabled: true,
        onMapCreated: (controller) async {
          await _repo.moveCamera(controller, _initialPosition);
        },
      ),
    );
  }
}
