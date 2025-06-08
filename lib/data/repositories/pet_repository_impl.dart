import 'package:pet_map/data/datasources/pet_local_datasource.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/domain/revositories/pet_repository.dart';

import '../models/pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final PetLocalDataSource _source;
  PetRepositoryImpl(this._source);

  @override
  Future<List<Pet>> getAll() async {
    final list = await _source.getAll();
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Pet> add(Pet pet) async {
    final id = await _source.insert(PetModel.fromEntity(pet));
    return pet.copyWith(id: id);
  }

  @override
  Future<void> update(Pet pet) => _source.update(PetModel.fromEntity(pet));

  @override
  Future<void> delete(int id) => _source.delete(id);
}
