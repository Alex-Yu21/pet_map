import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VetClinic {
  static const List<String> allSpecializations = [
    'кошки/собаки',
    'грызуны',
    'рептилии',
    'птицы',
  ];

  final String id;
  final String name;
  final LatLng point;
  final String? address;
  final String? phone;
  final bool visible;
  final bool isCustom;
  final List<String> specializations;

  VetClinic({
    required this.id,
    required this.name,
    required this.point,
    this.address,
    this.phone,
    this.visible = true,
    this.isCustom = false,
    List<String>? specializations,
  }) : specializations =
           (specializations == null || specializations.isEmpty)
               ? <String>[allSpecializations.first]
               : specializations;

  VetClinic copyWith({bool? visible, List<String>? specializations}) {
    final updated = VetClinic(
      id: id,
      name: name,
      point: point,
      address: address,
      phone: phone,
      visible: visible ?? this.visible,
      isCustom: isCustom,
      specializations: specializations ?? this.specializations,
    );
    debugPrint(
      'VetClinic.copyWith(): id=$id visible=${updated.visible} specs=${updated.specializations}',
    );
    return updated;
  }
}
