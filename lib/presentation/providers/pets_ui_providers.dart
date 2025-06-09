import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/app_providers.dart';
import '../../domain/entities/pet.dart';

final petsProvider = FutureProvider<List<Pet>>(
  (ref) => ref.watch(getPetsUCProvider).call(),
);

final petControllerProvider = Provider<PetController>(
  (ref) => PetController(ref),
);

class PetController {
  final Ref ref;
  PetController(this.ref);

  Future<void> addPet(Pet pet) async {
    await ref.read(addPetUCProvider).call(pet);
    ref.invalidate(petsProvider);
  }

  Future<void> updatePet(Pet pet) async {
    await ref.read(updatePetUCProvider).call(pet);
    ref.invalidate(petsProvider);
  }

  Future<void> deletePet(int id) async {
    await ref.read(deletePetUCProvider).call(id);
    ref.invalidate(petsProvider);
  }
}
