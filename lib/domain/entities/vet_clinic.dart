import 'package:google_maps_flutter/google_maps_flutter.dart';

class VetClinic {
  final String id;
  final String name;
  final LatLng point;
  final String? address;
  final String? phone;
  final bool visible;
  final bool isCustom;
  final List<String> specializations;

  const VetClinic({
    required this.id,
    required this.name,
    required this.point,
    this.address,
    this.phone,
    this.visible = true,
    this.isCustom = false,
    this.specializations = const ['кошки/собаки'],
  });

  VetClinic copyWith({bool? visible, List<String>? specializations}) =>
      VetClinic(
        id: id,
        name: name,
        point: point,
        address: address,
        phone: phone,
        visible: visible ?? this.visible,
        isCustom: isCustom,
        specializations: specializations ?? this.specializations,
      );
}
