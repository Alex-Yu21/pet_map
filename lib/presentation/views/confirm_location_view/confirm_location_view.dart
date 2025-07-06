import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmLocationView extends StatefulWidget {
  final LatLng initial;
  const ConfirmLocationView({super.key, required this.initial});

  @override
  State<ConfirmLocationView> createState() => _ConfirmLocationViewState();
}

class _ConfirmLocationViewState extends State<ConfirmLocationView> {
  late LatLng _point;

  @override
  void initState() {
    super.initState();
    _point = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _point, zoom: 16),
            onCameraMove: (pos) => _point = pos.target,
            markers: {
              Marker(
                markerId: const MarkerId('chosen'),
                position: _point,
                draggable: true,
                onDragEnd: (p) => _point = p,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
            },
            myLocationButtonEnabled: true,
          ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_point),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: const StadiumBorder(),
              ),
              child: const Text('добавить тут'),
            ),
          ),
        ],
      ),
    );
  }
}
