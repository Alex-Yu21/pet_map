import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/presentation/providers/nav_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';

typedef OnEdit = void Function();
typedef OnDelete = Future<void> Function();

class MenuButton extends StatelessWidget {
  final Pet? pet;
  final VetClinic? clinic;
  final OnEdit onEdit;
  final OnDelete onDelete;
  final WidgetRef ref;

  const MenuButton.pet({
    super.key,
    required this.pet,
    required this.onEdit,
    required this.onDelete,
    required this.ref,
  }) : clinic = null;

  const MenuButton.clinic({
    super.key,
    required this.clinic,
    required this.onEdit,
    required this.onDelete,
    required this.ref,
  }) : pet = null;

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      barrierColor: const Color(0x33000000),
      context: context,
      builder:
          (ctx) => Container(
            padding: EdgeInsets.all(Paddings.l),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Label('Удалить карточку?'),
                Label('(данное действие нельзя будет отменить)'),
                SizedBox(height: Paddings.l),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Label('отмена'),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary),
                        ),
                        child: const Label('удалить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
    if (confirmed == true) await onDelete();
  }

  Future<void> _openMenu(BuildContext context) async {
    ref.read(navBarShadowProvider.notifier).state = false;
    await showModalBottomSheet(
      barrierColor: const Color(0x33000000),
      context: context,
      builder:
          (ctx) => Container(
            padding: EdgeInsets.all(Paddings.l),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    splashRadius: IconSizes.m,
                    icon: Icon(Icons.close, color: AppColors.primary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                ListTile(
                  title: const Label('Редактировать'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onEdit();
                  },
                ),
                ListTile(
                  title: const Label('Удалить'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _confirmDelete(context);
                  },
                ),
              ],
            ),
          ),
    );
    ref.read(navBarShadowProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) => IconButton(
    splashRadius: IconSizes.m,
    icon: Icon(Icons.more_horiz, color: AppColors.secondary),
    onPressed: () => _openMenu(context),
  );
}
