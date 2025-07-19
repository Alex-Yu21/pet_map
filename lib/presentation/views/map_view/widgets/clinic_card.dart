import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/presentation/providers/clinic_providers.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/add_clinic_view/add_clinic_view.dart';
import 'package:pet_map/presentation/views/widgets/menu_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicCard extends ConsumerWidget {
  final VetClinic clinic;
  final VoidCallback onClose;
  const ClinicCard({super.key, required this.clinic, required this.onClose});

  Future<void> _call() async {
    final uri = Uri.parse('tel:${clinic.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void edit() => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => AddClinicView(initial: clinic)));
    Future<void> delete() => ref.read(toggleClinicProvider)(clinic.id);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Paddings.l,
        vertical: Paddings.l,
      ),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(Paddings.m),
        child: Container(
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
                  ref: ref,
                ),
              ),
              Text(
                clinic.name,
                style: TextStyle(
                  fontSize: FontSizes.description,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if ((clinic.phone ?? '').trim().isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: Paddings.xxs),
                  child: Text(clinic.phone!),
                ),
              if ((clinic.address ?? '').trim().isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: Paddings.xxs),
                  child: Text(clinic.address!),
                ),
              if (clinic.specializations.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: Paddings.xxs),
                  child: Text(clinic.specializations.join(', ')),
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
                        child: const Text('закрыть'),
                      ),
                    ),
                    SizedBox(width: Paddings.m),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            (clinic.phone ?? '').trim().isNotEmpty
                                ? _call
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: Paddings.s),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('позвонить'),
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
