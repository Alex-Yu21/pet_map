import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../entities/vet_clinic.dart';

abstract class ClinicsRepository {
  Stream<List<VetClinic>> watchClinics();
  Future<List<VetClinic>> getNearby(Point center, {double radiusMeters = 5000});
  Future<void> add(VetClinic clinic);
  Future<void> toggleVisibility(String id);
}
