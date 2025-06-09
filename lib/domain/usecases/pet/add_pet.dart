import '../../entities/pet.dart';
import '../../revositories/pet_repository.dart';

class AddPet {
  final PetRepository _repo;
  AddPet(this._repo);

  Future<Pet> call(Pet pet) => _repo.add(pet);
}
