import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_map/presentation/providers/map_providers.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  static const _initial = CameraPosition(
    target: Point(latitude: 59.9343, longitude: 30.3351),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(mapRepoProvider);

    ref.listen<AsyncValue<Position>>(posStreamProvider, (_, next) {
      next.whenData((pos) {
        final ctrl = ref.read(mapCtrlProvider);
        if (ctrl != null) {
          repo.moveCamera(
            ctrl,
            CameraPosition(
              target: Point(latitude: pos.latitude, longitude: pos.longitude),
              zoom: 15,
            ),
          );
        }
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (c) {
              ref.read(mapCtrlProvider.notifier).state = c;
              repo.moveCamera(c, _initial);
            },
          ),
          Positioned(
            right: 0,
            bottom: 30,
            child: IconButton(
              icon: const Icon(Icons.my_location, size: 46),
              onPressed: () async {
                final pos = await ref.read(currentPosProvider.future);
                final ctrl = ref.read(mapCtrlProvider);
                if (ctrl != null) {
                  repo.moveCamera(
                    ctrl,
                    CameraPosition(
                      target: Point(
                        latitude: pos.latitude,
                        longitude: pos.longitude,
                      ),
                      zoom: 15,
                    ),
                  );
                }
                ref.refresh(posStreamProvider);
              },
            ),
          ),
        ],
      ),
    );
  }
}
