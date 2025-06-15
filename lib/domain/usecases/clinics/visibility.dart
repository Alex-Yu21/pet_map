import 'package:pet_map/domain/revositories/clinics_repository.dart';

class ToggleVisibility {
  final ClinicsRepository _repo;
  const ToggleVisibility(this._repo);

  Future<void> call(String id) => _repo.toggleVisibility(id);
}
