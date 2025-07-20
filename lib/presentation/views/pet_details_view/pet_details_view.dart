import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/presentation/providers/pets_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/add_pet_view/add_pet_view.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';
import 'package:pet_map/presentation/views/widgets/menu_button.dart';

class PetDetailsView extends ConsumerWidget {
  final Pet pet;
  const PetDetailsView({super.key, required this.pet});

  Widget _petImage() {
    if (pet.photoPath?.isNotEmpty == true) {
      return Image.file(
        File(pet.photoPath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 170.h,
      );
    }
    return Image.asset(
      'assets/images/no_image.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: 170.h,
    );
  }

  String _ruDate(DateTime d) {
    const m = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openEdit() => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddPetView(initialPet: pet)),
    );

    Future<void> delete() async {
      await ref.read(petControllerProvider).deletePet(pet.id!);
      if (context.mounted) Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Paddings.l),
          child: Column(
            children: [
              Container(
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
                          ref: ref,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 5 / 3,
                          child: _petImage(),
                        ),
                      ),
                      SizedBox(height: Paddings.m),
                      const Label('Кличка', bottomPadding: 0),
                      Label(pet.name),
                      SizedBox(height: Paddings.m),
                      const Label('Дата  рождения', bottomPadding: 0),
                      Label(
                        pet.birthDate == null ? '' : _ruDate(pet.birthDate!),
                      ),
                      SizedBox(height: Paddings.m),
                      const Label('Порода', bottomPadding: 0),
                      Label(pet.breed ?? ''),
                      SizedBox(height: Paddings.m),
                      const Label('Стерилизация', bottomPadding: 0),
                      Label(pet.isSterilized ? 'да' : 'нет'),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 40.h,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: BorderSide(color: AppColors.primary),
                  ),
                  child: Text(
                    'на экран питомцев',
                    style: TextStyle(color: AppColors.primary, fontSize: 16.sp),
                  ),
                ),
              ),
              SizedBox(height: Paddings.l),
            ],
          ),
        ),
      ),
    );
  }
}
