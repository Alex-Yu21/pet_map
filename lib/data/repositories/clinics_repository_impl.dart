import 'dart:async';

import 'package:pet_map/data/datasources/local_clinic_ds.dart';
import 'package:pet_map/data/datasources/remote_clinic_ds.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/domain/revositories/clinics_repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class ClinicsRepositoryImpl implements ClinicsRepository {
  ClinicsRepositoryImpl(this._remote, this._local);

  final RemoteClinicDS _remote;
  final LocalClinicDS _local;

  final _stream = StreamController<List<VetClinic>>.broadcast();
  List<VetClinic> _cache = const [];

  @override
  Stream<List<VetClinic>> watchClinics() => _stream.stream;

  @override
  Future<List<VetClinic>> getNearby(
    Point center, {
    double radiusMeters = 5000,
  }) async {
    final remote = await _remote.search(center, radiusMeters);
    final hidden = _local.hiddenIds();
    final custom = _local.customClinics();

    _cache = [
      ...remote.map((c) => c.copyWith(visible: !hidden.contains(c.id))),
      ...custom,
    ];
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
