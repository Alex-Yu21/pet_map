import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/add_pet_view/add_pet_view.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: const BorderSide(color: AppColors.secondary, width: 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        splashColor: AppColors.secondary.withAlpha((0.15 * 255).round()),
        highlightColor: Colors.transparent,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPetView()),
            ),
        child: SizedBox(
          width: double.infinity,
          height: 120.h,
          child: Center(
            child: SizedBox(
              width: IconSizes.xxl,
              height: IconSizes.xxl,
              child: SvgPicture.asset(
                'assets/icons/add_circle.svg',
                color: AppColors.secondary,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
