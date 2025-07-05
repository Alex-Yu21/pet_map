import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/vet_clinic.dart';
import '../../domain/repositories/clinics_repository.dart';
import '../datasources/local_clinic_ds.dart';

class ClinicsRepositoryImpl implements ClinicsRepository {
  ClinicsRepositoryImpl(this._local) {
    _cache = _local.customClinics();
    _stream = StreamController<List<VetClinic>>.broadcast();
    Future.microtask(() {
      _stream.add(_cache);
      debugPrint('initial emit → ${_cache.length} clinics');
    });
  }

  final LocalClinicDS _local;

  late final StreamController<List<VetClinic>> _stream;
  late List<VetClinic> _cache;

  @override
  Stream<List<VetClinic>> watchClinics() => _stream.stream;

  @override
  Future<List<VetClinic>> getNearby(
    LatLng center, {
    double radiusMeters = 5000,
  }) async {
    final all = _local.customClinics();
    final hidden = _local.hiddenIds();
    _cache =
        all.map((c) => c.copyWith(visible: !hidden.contains(c.id))).toList();
    _stream.add(_cache);
    debugPrint('getNearby emit → ${_cache.length} clinics');
    return _cache;
  }

  @override
  Future<void> add(VetClinic clinic) async {
    await _local.addCustom(clinic);
    _cache = [..._cache, clinic];
    _stream.add(_cache);
  }

  @override
  Future<void> toggleVisibility(String id) async {
    await _local.toggle(id);
    _cache =
        _cache
            .map((c) => c.id == id ? c.copyWith(visible: !c.visible) : c)
            .toList();
    _stream.add(_cache);
  }
}
