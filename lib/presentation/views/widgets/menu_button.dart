import 'package:flutter/material.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';

typedef OnEdit = void Function();
typedef OnDelete = Future<void> Function();

class MenuButton extends StatelessWidget {
  final Pet pet;
  final OnEdit onEdit;
  final OnDelete onDelete;

  const MenuButton({
    super.key,
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  });

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.only(
              left: Paddings.l,
              right: Paddings.l,
              top: Paddings.l,
              bottom: MediaQuery.of(ctx).padding.bottom + Paddings.l,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    splashRadius: 20,
                    icon: Icon(Icons.close, color: AppColors.primary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
                ListTile(
                  title: const Text('Редактировать'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onEdit();
                  },
                ),
                ListTile(
                  title: const Text('Удалить'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onDelete();
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      icon: Icon(Icons.more_horiz, color: AppColors.secondary),
      onPressed: () => _openMenu(context),
    );
  }
}
