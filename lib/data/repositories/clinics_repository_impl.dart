import 'dart:async';

import 'package:pet_map/domain/repositories/clinics_repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../domain/entities/vet_clinic.dart';
import '../datasources/local_clinic_ds.dart';

class ClinicsRepositoryImpl implements ClinicsRepository {
  ClinicsRepositoryImpl(this._local);

  final LocalClinicDS _local;

  final _stream = StreamController<List<VetClinic>>.broadcast();
  List<VetClinic> _cache = const [];

  @override
  Stream<List<VetClinic>> watchClinics() => _stream.stream;

  @override
  Future<List<VetClinic>> getNearby(
    Point center, {
    double radiusMeters = 5_000,
  }) async {
    final all = _local.customClinics();
    final hidden = _local.hiddenIds();

    _cache =
        all.map((c) => c.copyWith(visible: !hidden.contains(c.id))).toList();
    _stream.add(_cache);
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
