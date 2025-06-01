import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late YandexMapController _mapController;

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: Point(latitude: 59.9343, longitude: 30.3351), // Санкт-Петербург
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        zoomGesturesEnabled: true,
        onMapCreated: (controller) async {
          _mapController = controller;
          await _mapController.moveCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
        },
      ),
    );
  }
}
