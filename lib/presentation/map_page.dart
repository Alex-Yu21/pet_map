import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  late String lat;
  late String long;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions',
      );
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            zoomGesturesEnabled: true,
            onMapCreated: (controller) async {
              await _repo.moveCamera(controller, _initialPosition);
            },
          ),
          Positioned(
            bottom: 30,
            right: 0,
            child: IconButton(
              onPressed: () {
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                });
              },
              icon: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
