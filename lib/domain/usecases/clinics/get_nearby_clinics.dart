import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/domain/revositories/clinics_repository.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class GetNearbyClinics {
  final ClinicsRepository _repo;
  const GetNearbyClinics(this._repo);

  Future<List<VetClinic>> call(Point center, {double radius = 5000}) =>
      _repo.getNearby(center, radiusMeters: radius);
}
