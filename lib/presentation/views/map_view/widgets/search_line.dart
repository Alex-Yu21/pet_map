import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_map/presentation/providers/search_provider.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';

class SearchLine extends ConsumerWidget {
  final VoidCallback onFilterTap;
  const SearchLine({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: Paddings.l,
        vertical: Paddings.s,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.secondary, width: 1.5),
                borderRadius: BorderRadius.circular(24.h),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20.w),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: query)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: query.length),
                        ),
                      decoration: InputDecoration(
                        hintText: 'поиск клиники',
                        hintStyle: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged:
                          (v) =>
                              ref.read(searchQueryProvider.notifier).state = v,
                    ),
                  ),
                  Icon(Icons.search, color: AppColors.primary, size: 28.w),
                  SizedBox(width: 18.w),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(24.w),
            child: Container(
              width: 48.w,
              height: 48.w,
              alignment: Alignment.center,
              child: Icon(Icons.tune, color: AppColors.primary, size: 24.w),
            ),
          ),
        ],
      ),
    );
  }
}
