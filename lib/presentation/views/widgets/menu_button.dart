import 'package:flutter/material.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';

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

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
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
                SizedBox(height: 24),
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

    if (confirmed == true) {
      await onDelete();
    }
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            padding: EdgeInsets.only(
              left: Paddings.l,
              right: Paddings.l,
              top: Paddings.l,
              bottom: Paddings.l,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                  title: Label('Редактировать'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onEdit();
                  },
                ),
                ListTile(
                  title: Label('Удалить'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _confirmDelete(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => IconButton(
    splashRadius: 20,
    icon: Icon(Icons.more_horiz, color: AppColors.secondary),
    onPressed: () => _openMenu(context),
  );
}
