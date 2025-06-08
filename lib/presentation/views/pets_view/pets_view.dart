import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/presentation/providers/pet_providers.dart';

class PetsView extends ConsumerWidget {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return petsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data:
          (pets) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pets.length,
            itemBuilder: (_, i) => PetCard(pet: pets[i]),
          ),
    );
  }
}

class PetCard extends StatelessWidget {
  final Pet pet;
  const PetCard({required this.pet, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
          const Placeholder(fallbackHeight: 100),
          Text(pet.name, style: Theme.of(context).textTheme.titleMedium),
          ElevatedButton(onPressed: () {}, child: const Text('Подробнее')),
        ],
      ),
    );
  }
}
