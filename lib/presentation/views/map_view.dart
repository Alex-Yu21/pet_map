import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_map/presentation/providers/map_providers.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView>
    with AutomaticKeepAliveClientMixin {
  static const _initial = CameraPosition(
    target: Point(latitude: 59.9343, longitude: 30.3351),
    zoom: 12,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<AsyncValue<Position>>(posStreamProvider, (prev, next) async {
      next.whenData((pos) async {
        final ctrl = ref.read(mapCtrlProvider);
        if (ctrl != null) {
          await ref
              .read(mapRepoProvider)
              .moveCamera(
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
      });
    });

    final repo = ref.read(mapRepoProvider);

    return Stack(
      children: [
        YandexMap(
          onMapCreated: (c) async {
            ref.read(mapCtrlProvider.notifier).state = c;
            await repo.moveCamera(c, _initial);
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
                await repo.moveCamera(
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
              ref.invalidate(posStreamProvider);
            },
          ),
        ),
      ],
    );
  }
}
