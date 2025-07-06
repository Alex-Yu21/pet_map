import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/di/app_providers.dart';
import 'package:pet_map/presentation/providers/clinic_providers.dart';
import 'package:pet_map/presentation/providers/map_position_providers.dart';
import 'package:pet_map/presentation/providers/map_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/add_clinic_view/add_clinic_view.dart';
import 'package:pet_map/presentation/views/map_view/widgets/clinic_card.dart';
import 'package:pet_map/presentation/views/map_view/widgets/filter_panel.dart';
import 'package:pet_map/presentation/views/map_view/widgets/search_line.dart';
import 'package:pet_map/presentation/views/map_view/widgets/search_overlay.dart';

import 'widgets/location_button.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});
  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView>
    with AutomaticKeepAliveClientMixin {
  static const _initial = CameraPosition(
    target: LatLng(59.9343, 30.3351),
    zoom: 12,
  );

  bool _showFilter = false;
  void _toggleFilter() => setState(() => _showFilter = !_showFilter);

  Future<void> _loadNearby(LatLng center) async {
    await ref.read(clinicsRepositoryProvider).getNearby(center);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ref.listen<AsyncValue<Position>>(posStreamProvider, (_, next) {
      next.whenData((pos) async {
        final ctrl = ref.read(mapCtrlProvider);
        if (ctrl != null) {
          final target = LatLng(pos.latitude, pos.longitude);
          await ref
              .read(mapRepositoryProvider)
              .moveCamera(ctrl, CameraPosition(target: target, zoom: 15));
          _loadNearby(target);
        }
      });
    });

    final markersAsync = ref.watch(filteredClinicsProvider);
    final iconAsync = ref.watch(customClinicMarkerProvider);
    final selected = ref.watch(selectedClinicProvider);
    final repo = ref.read(mapRepositoryProvider);
    final topOffset = MediaQuery.of(context).padding.top + 72;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initial,
            onMapCreated: (c) async {
              ref.read(mapCtrlProvider.notifier).state = c;
              await repo.moveCamera(c, _initial);
              ref.read(lastCameraPositionProvider.notifier).state = _initial;
              _loadNearby(_initial.target);
            },
            onCameraIdle: () {
              final pos = ref.read(lastCameraPositionProvider);
              if (pos != null) _loadNearby(pos.target);
            },
            onCameraMove:
                (pos) =>
                    ref.read(lastCameraPositionProvider.notifier).state = pos,
            myLocationEnabled: true,
            markers: markersAsync.when<Set<Marker>>(
              data: (list) {
                final icon = iconAsync.maybeWhen(
                  data: (i) => i,
                  orElse: () => null,
                );
                return list
                    .map(
                      (c) => Marker(
                        markerId: MarkerId(c.id),
                        position: c.point,
                        infoWindow: const InfoWindow(),
                        icon: icon ?? BitmapDescriptor.defaultMarker,
                        onTap:
                            () =>
                                ref
                                    .read(selectedClinicProvider.notifier)
                                    .state = c,
                      ),
                    )
                    .toSet();
              },
              loading: () => {},
              error: (_, __) => {},
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: SearchLine(onFilterTap: _toggleFilter),
          ),
          if (_showFilter)
            Positioned(
              top: topOffset,
              left: 0,
              right: 0,
              child: const FilterPanel(),
            ),
          SearchOverlay(topOffset: topOffset),
          if (selected != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClinicCard(
                clinic: selected,
                onClose:
                    () =>
                        ref.read(selectedClinicProvider.notifier).state = null,
              ),
            ),
          Positioned(
            right: Paddings.l,
            bottom: Paddings.xl,
            child: LocationButton(ref: ref, repo: repo),
          ),
          if (selected == null)
            Positioned(
              bottom: Paddings.s,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddClinicView(),
                        ),
                      ),
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('добавить клинику'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
