import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_map/domain/map_repository.dart';
import 'package:pet_map/presentation/providers/map_providers.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class LocationButton extends StatelessWidget {
  const LocationButton({super.key, required this.ref, required this.repo});

  final WidgetRef ref;
  final MapRepository repo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: IconSizes.xl,
      height: IconSizes.xl,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: Paddings.xxs),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: SvgPicture.asset('assets/icons/geo.svg', width: IconSizes.m),
        onPressed: () async {
          final pos = await ref.read(currentPosProvider.future);
          final ctrl = ref.read(mapCtrlProvider);
          if (ctrl != null) {
            await repo.moveCamera(
              ctrl,
              CameraPosition(
                target: Point(latitude: pos.latitude, longitude: pos.longitude),
                zoom: 15,
              ),
            );
          }
          ref.invalidate(posStreamProvider);
        },
      ),
    );
  }
}
