import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../di/app_providers.dart';

final currentPosProvider = FutureProvider.autoDispose<Position>(
  (ref) => ref.watch(getCurrentPosUCProvider).call(),
);

final posStreamProvider = StreamProvider.autoDispose<Position>(
  (ref) => ref.watch(streamPosUCProvider).call(),
);

final lastCameraPositionProvider = StateProvider<CameraPosition?>((_) => null);
