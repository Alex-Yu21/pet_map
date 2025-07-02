import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/domain/repositories/clinics_repository.dart';

class GetNearbyClinics {
  final ClinicsRepository _repo;
  const GetNearbyClinics(this._repo);

  Future<List<VetClinic>> call(LatLng center, {double radius = 5000}) =>
      _repo.getNearby(center, radiusMeters: radius);
}
