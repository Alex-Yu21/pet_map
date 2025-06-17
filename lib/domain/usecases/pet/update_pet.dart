import '../../entities/pet.dart';
import '../../repositories/pet_repository.dart';

class UpdatePet {
  final PetRepository _repo;
  UpdatePet(this._repo);

  Future<void> call(Pet pet) => _repo.update(pet);
}
