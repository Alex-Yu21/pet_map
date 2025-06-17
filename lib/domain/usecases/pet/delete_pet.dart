import '../../repositories/pet_repository.dart';

class DeletePet {
  final PetRepository _repo;
  DeletePet(this._repo);

  Future<void> call(int id) => _repo.delete(id);
}
