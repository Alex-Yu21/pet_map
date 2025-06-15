import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../domain/entities/vet_clinic.dart';

class LocalClinicDS {
  static const _hiddenKey = 'hidden_clinic_ids';
  static const _customKey = 'custom_clinics';
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Set<String> _hidden() =>
      _prefs.getStringList(_hiddenKey)?.toSet() ?? <String>{};

  bool isHidden(String id) => _hidden().contains(id);

  Future<void> toggle(String id) async {
    final set = _hidden();
    set.contains(id) ? set.remove(id) : set.add(id);
    await _prefs.setStringList(_hiddenKey, set.toList());
  }

  List<VetClinic> _custom() {
    final raw = _prefs.getString(_customKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map(
          (e) => VetClinic(
            id: e['id'],
            name: e['name'],
            point: Point(latitude: e['lat'], longitude: e['lon']),
            address: e['address'],
            phone: e['phone'],
            visible: e['visible'],
            isCustom: true,
          ),
        )
        .toList();
  }

  Future<void> addCustom(VetClinic c) async {
    final list = _custom()..add(c);
    await _prefs.setString(
      _customKey,
      jsonEncode(
        list
            .map(
              (v) => {
                'id': v.id,
                'name': v.name,
                'lat': v.point.latitude,
                'lon': v.point.longitude,
                'address': v.address,
                'phone': v.phone,
                'visible': v.visible,
              },
            )
            .toList(),
      ),
    );
  }

  List<VetClinic> customClinics() => _custom();
  Set<String> hiddenIds() => _hidden();
}
