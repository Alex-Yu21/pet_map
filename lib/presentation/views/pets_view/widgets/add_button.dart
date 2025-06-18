import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
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
        height: 120.h,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.secondary, width: 2),
          borderRadius: BorderRadius.circular(64),
        ),
        alignment: Alignment.center,
        child: Container(
          width: IconSizes.xxl,
          height: IconSizes.xxl,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary, width: 8),
          ),
          child: Icon(Icons.add, size: 64.h, color: AppColors.secondary),
        ),
      ),
    );
  }
}
