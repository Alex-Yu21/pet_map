import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_map/di/app_providers.dart';
import 'package:pet_map/presentation/providers/map_position_providers.dart';
import 'package:pet_map/presentation/providers/map_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/map_view/widgets/location_button.dart';
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

    ref.listen<AsyncValue<Position>>(posStreamProvider, (_, next) {
      next.whenData((pos) async {
        final ctrl = ref.read(mapCtrlProvider);
        if (ctrl != null) {
          await ref
              .read(mapRepositoryProvider)
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

    final repo = ref.read(mapRepositoryProvider);

    return Stack(
      children: [
        YandexMap(
          onMapCreated: (c) async {
            ref.read(mapCtrlProvider.notifier).state = c;
            await repo.moveCamera(c, _initial);
          },
        ),
        Positioned(
          right: Paddings.l,
          bottom: Paddings.xl,
          child: LocationButton(ref: ref, repo: repo),
        ),
      ],
    );
  }
}
