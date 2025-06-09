import 'package:flutter/material.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/add_pet_view/add_pet_view.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap:
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddPetView())),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF9E9E9E), width: 4),
          ),
          child: Icon(Icons.add, size: IconSizes.xl, color: Color(0xFF9E9E9E)),
        ),
      ),
    );
  }
}
