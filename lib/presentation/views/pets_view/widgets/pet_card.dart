import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/presentation/providers/pets_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/add_pet_view/add_pet_view.dart';

class PetCard extends ConsumerWidget {
  final Pet pet;
  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    Future<void> deletePet() =>
        ref.read(petControllerProvider).deletePet(pet.id!);

    void openDetails() => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => AddPetView(initialPet: pet)));

    Widget petImage() {
      if (pet.photoPath != null && pet.photoPath!.isNotEmpty) {
        return Image.file(
          File(pet.photoPath!),
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
      return Container(
        height: 120,
        width: double.infinity,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Image.asset('assets/images/no_image.png'),
      );
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: Paddings.l),
      child: Padding(
        padding: EdgeInsets.all(Paddings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton<String>(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      openDetails();
                      break;
                    case 'delete':
                      deletePet();
                      break;
                  }
                },
                itemBuilder:
                    (_) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Редактировать'),
                      ),
                      PopupMenuItem(value: 'delete', child: Text('Удалить')),
                    ],
                icon: const Icon(Icons.more_horiz),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: petImage(),
            ),
            SizedBox(height: Paddings.m),
            Text(pet.name, style: theme.textTheme.titleMedium),
            SizedBox(height: Paddings.m),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: Paddings.l,
                    vertical: Paddings.m,
                  ),
                  shape: const StadiumBorder(),
                ),
                onPressed: openDetails,
                child: const Text('подробнее'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
