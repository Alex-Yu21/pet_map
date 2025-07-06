import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/presentation/providers/pets_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/add_pet_view/add_pet_view.dart';
import 'package:pet_map/presentation/views/pet_view/pet_view.dart';
import 'package:pet_map/presentation/views/widgets/menu_button.dart';

class PetCard extends ConsumerWidget {
  const PetCard({super.key, required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> delete() => ref.read(petControllerProvider).deletePet(pet.id!);

    void openDetails() => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PetView(pet: pet)),
    );

    void openEdit() => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddPetView(initialPet: pet)),
    );

    Widget petImage() {
      if (pet.photoPath?.isNotEmpty == true) {
        return Image.file(File(pet.photoPath!), fit: BoxFit.cover);
      }
      return Image.asset('assets/images/no_image.png', fit: BoxFit.cover);
    }

    return Container(
      margin: EdgeInsets.only(bottom: Paddings.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary, width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(Paddings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: MenuButton.pet(
                pet: pet,
                onEdit: openEdit,
                onDelete: delete,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(aspectRatio: 5 / 3, child: petImage()),
            ),
            SizedBox(height: Paddings.m),
            Text(pet.name),
            SizedBox(height: Paddings.m),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: openDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.symmetric(
                    horizontal: Paddings.l,
                    vertical: Paddings.s,
                  ),
                  elevation: 0,
                ),
                child: const Text('подробнее'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
