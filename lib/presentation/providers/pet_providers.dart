import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/data/datasources/pet_local_datasource.dart';
import 'package:pet_map/data/repositories/pet_repository_impl.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/domain/revositories/pet_repository.dart';

final _localSourceProvider = Provider<PetLocalDataSource>(
  (_) => PetLocalDataSource(),
);

final petRepoProvider = Provider<PetRepository>(
  (ref) => PetRepositoryImpl(ref.read(_localSourceProvider)),
);

final petsProvider = FutureProvider<List<Pet>>((ref) {
  return ref.read(petRepoProvider).getAll();
});

final petControllerProvider = Provider<PetController>(
  (ref) => PetController(ref),
);

class PetController {
  final Ref ref;
  PetController(this.ref);

  Future<void> addPet(Pet pet) async {
    await ref.read(petRepoProvider).add(pet);
    ref.invalidate(petsProvider);
  }

  Future<void> updatePet(Pet pet) async {
    await ref.read(petRepoProvider).update(pet);
    ref.invalidate(petsProvider);
  }

  Future<void> deletePet(int id) async {
    await ref.read(petRepoProvider).delete(id);
    ref.invalidate(petsProvider);
  }
}
