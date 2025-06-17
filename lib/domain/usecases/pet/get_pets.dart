import '../../entities/pet.dart';
import '../../repositories/pet_repository.dart';

class GetPets {
  final PetRepository _repo;
  GetPets(this._repo);

  Future<List<Pet>> call() => _repo.getAll();
}
