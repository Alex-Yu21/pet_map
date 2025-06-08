import 'package:pet_map/domain/entities/pet.dart';

class PetModel {
  final int? id;
  final String name;
  final String? photoPath;
  final int? birthDateInt;
  final String? breed;
  final int isSterilized; // 0 / 1 в SQLite

  PetModel({
    this.id,
    required this.name,
    this.photoPath,
    this.birthDateInt,
    this.breed,
    required this.isSterilized,
  });

  factory PetModel.fromEntity(Pet pet) => PetModel(
    id: pet.id,
    name: pet.name,
    photoPath: pet.photoPath,
    birthDateInt: pet.birthDate?.millisecondsSinceEpoch,
    breed: pet.breed,
    isSterilized: pet.isSterilized ? 1 : 0,
  );

  Pet toEntity() => Pet(
    id: id,
    name: name,
    photoPath: photoPath,
    birthDate:
        birthDateInt != null
            ? DateTime.fromMillisecondsSinceEpoch(birthDateInt!)
            : null,
    breed: breed,
    isSterilized: isSterilized == 1,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'photoPath': photoPath,
    'birthDate': birthDateInt,
    'breed': breed,
    'isSterilized': isSterilized,
  };

  factory PetModel.fromMap(Map<String, Object?> map) => PetModel(
    id: map['id'] as int?,
    name: map['name'] as String,
    photoPath: map['photoPath'] as String?,
    birthDateInt: map['birthDate'] as int?,
    breed: map['breed'] as String?,
    isSterilized: map['isSterilized'] as int,
  );
}
