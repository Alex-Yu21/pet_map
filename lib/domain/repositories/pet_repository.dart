import '../entities/pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getAll();
  Future<Pet> add(Pet pet);
  Future<void> update(Pet pet);
  Future<void> delete(int id);
}
