class Pet {
  final int? id;
  final String name;
  final String? photoPath;
  final DateTime? birthDate;
  final String? breed;
  final bool isSterilized;

  const Pet({
    this.id,
    required this.name,
    this.photoPath,
    this.birthDate,
    this.breed,
    required this.isSterilized,
  });

  Pet copyWith({
    int? id,
    String? name,
    String? photoPath,
    DateTime? birthDate,
    String? breed,
    bool? isSterilized,
  }) => Pet(
    id: id ?? this.id,
    name: name ?? this.name,
    photoPath: photoPath ?? this.photoPath,
    birthDate: birthDate ?? this.birthDate,
    breed: breed ?? this.breed,
    isSterilized: isSterilized ?? this.isSterilized,
  );
}
