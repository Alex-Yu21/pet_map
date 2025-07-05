import 'package:flutter_test/flutter_test.dart';
import 'package:pet_map/data/datasources/pet_local_ds.dart';
import 'package:pet_map/data/repositories/pet_repository_impl.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late PetLocalDataSource localDataSource;
  late PetRepositoryImpl repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    localDataSource = PetLocalDataSource();
    repository = PetRepositoryImpl(localDataSource);
  });

  test('Добавление, обновление и удаление питомца', () async {
    final pet = Pet(name: 'Мурзик', isSterilized: false);
    final addedPet = await repository.add(pet);

    final allAfterAdd = await repository.getAll();
    expect(allAfterAdd.length, 1);
    expect(allAfterAdd.first.name, 'Мурзик');
    expect(addedPet.id, isNotNull);

    final updatedPet = addedPet.copyWith(name: 'Барсик', isSterilized: true);
    await repository.update(updatedPet);

    final allAfterUpdate = await repository.getAll();
    expect(allAfterUpdate.first.name, 'Барсик');
    expect(allAfterUpdate.first.isSterilized, true);

    await repository.delete(updatedPet.id!);

    final allAfterDelete = await repository.getAll();
    expect(allAfterDelete, isEmpty);
  });
}
