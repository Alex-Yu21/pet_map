import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entities/vet_clinic.dart';

abstract class ClinicsRepository {
  Stream<List<VetClinic>> watchClinics();
  Future<List<VetClinic>> getNearby(
    LatLng center, {
    double radiusMeters = 5000,
  });
  Future<void> add(VetClinic clinic);
  Future<void> toggleVisibility(String id);
}
