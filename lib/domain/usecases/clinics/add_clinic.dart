import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/domain/revositories/clinics_repository.dart';

class AddClinic {
  final ClinicsRepository _repo;
  const AddClinic(this._repo);

  Future<void> call(VetClinic clinic) => _repo.add(clinic);
}
