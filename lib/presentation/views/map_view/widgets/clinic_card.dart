import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/presentation/providers/clinic_providers.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/add_clinic_view/add_clinic_view.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';
import 'package:pet_map/presentation/views/widgets/menu_button.dart';

class ClinicCard extends ConsumerWidget {
  final VetClinic clinic;
  final VoidCallback onClose;
  const ClinicCard({super.key, required this.clinic, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void edit() => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => AddClinicView(initial: clinic)));
    Future<void> delete() => ref.read(toggleClinicProvider)(clinic.id);

    return Padding(
      padding: EdgeInsets.fromLTRB(Paddings.l, 0, Paddings.l, Paddings.l),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(Paddings.m),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(Paddings.l),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Paddings.m),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: MenuButton.clinic(
                  clinic: clinic,
                  onEdit: edit,
                  onDelete: delete,
                ),
              ),
              Text(
                clinic.name,
                style: TextStyle(fontSize: FontSizes.description),
              ),
              if ((clinic.phone ?? '').trim().isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: Paddings.xxs),
                  child: Label(clinic.phone!),
                ),
              if ((clinic.address ?? '').trim().isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: Paddings.xxs),
                  child: Label(clinic.address!),
                ),
              if (clinic.specializations.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: Paddings.xxs),
                  child: Label(clinic.specializations.join(', ')),
                ),
              Padding(
                padding: EdgeInsets.only(top: Paddings.m),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onClose,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: Paddings.s),
                          foregroundColor: AppColors.primary,
                          side: BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        child: const Label('закрыть'),
                      ),
                    ),
                    SizedBox(width: Paddings.m),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: Paddings.s),
                          shape: const StadiumBorder(),
                        ),
                        child: const Label('позвонить'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
