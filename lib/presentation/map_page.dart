import 'dart:async';

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
  YandexMapController? _mapController;
  StreamSubscription<Position>? _posSub;
  double? lat;
  double? long;

  void _liveLocation() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    _posSub = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
      if (_mapController != null) {
        _repo.moveCamera(
          _mapController!,
          CameraPosition(
            target: Point(
              latitude: position.latitude,
              longitude: position.longitude,
            ),
            zoom: 15,
          ),
        );
      }
    });
  }

  Future<Position> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled');
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
    return Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    _posSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            zoomGesturesEnabled: true,
            onMapCreated: (controller) async {
              _mapController = controller;
              await _repo.moveCamera(controller, _initialPosition);
            },
          ),
          Positioned(
            bottom: 30,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () async {
                final pos = await _getCurrentLocation();
                setState(() {
                  lat = pos.latitude;
                  long = pos.longitude;
                });
                if (_mapController != null) {
                  await _repo.moveCamera(
                    _mapController!,
                    CameraPosition(
                      target: Point(
                        latitude: pos.latitude,
                        longitude: pos.longitude,
                      ),
                      zoom: 15,
                    ),
                  );
                }
                _liveLocation();
              },
            ),
          ),
        ],
      ),
    );
  }
}
