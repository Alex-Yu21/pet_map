import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapCtrlProvider = StateProvider<GoogleMapController?>((_) => null);

final customClinicMarkerProvider = FutureProvider<BitmapDescriptor>((
  ref,
) async {
  final bytes = await rootBundle.load('assets/images/clinic_pin.png');
  return BitmapDescriptor.bytes(bytes.buffer.asUint8List());
});
