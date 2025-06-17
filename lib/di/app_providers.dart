import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/repositories/map_repository.dart';
import 'package:pet_map/domain/repositories/pet_repository.dart';
import 'package:pet_map/domain/usecases/location/get_current_position.dart';
import 'package:pet_map/domain/usecases/location/stream_position.dart';
import 'package:pet_map/domain/usecases/pet/add_pet.dart';
import 'package:pet_map/domain/usecases/pet/delete_pet.dart';
import 'package:pet_map/domain/usecases/pet/get_pets.dart';
import 'package:pet_map/domain/usecases/pet/update_pet.dart';

import '../data/datasources/pet_local_datasource.dart';
import '../data/repositories/map_repository_impl.dart';
import '../data/repositories/pet_repository_impl.dart';
import '../data/services/location_service.dart';

final _petLocalDsProvider = Provider<PetLocalDataSource>(
  (_) => PetLocalDataSource(),
);

final petRepositoryProvider = Provider<PetRepository>(
  (ref) => PetRepositoryImpl(ref.read(_petLocalDsProvider)),
);

final mapRepositoryProvider = Provider<MapRepository>(
  (_) => MapRepositoryImpl(),
);

final getPetsUCProvider = Provider(
  (ref) => GetPets(ref.read(petRepositoryProvider)),
);
final addPetUCProvider = Provider(
  (ref) => AddPet(ref.read(petRepositoryProvider)),
);
final updatePetUCProvider = Provider(
  (ref) => UpdatePet(ref.read(petRepositoryProvider)),
);
final deletePetUCProvider = Provider(
  (ref) => DeletePet(ref.read(petRepositoryProvider)),
);

final getCurrentPosUCProvider = Provider(
  (_) => GetCurrentPosition(LocationService.getOnce),
);
final streamPosUCProvider = Provider(
  (_) => StreamPosition(LocationService.stream),
);
