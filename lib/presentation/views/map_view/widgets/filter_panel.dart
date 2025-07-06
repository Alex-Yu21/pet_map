import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/presentation/providers/clinic_providers.dart';
import 'package:pet_map/presentation/providers/filter_provider.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';

class FilterPanel extends ConsumerWidget {
  const FilterPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active =
        ref
            .watch(clinicsStreamProvider)
            .asData
            ?.value
            .expand((e) => e.specializations)
            .toSet() ??
        {};
    final specs = [
      ...VetClinic.allSpecializations,
      ...active.where((e) => !VetClinic.allSpecializations.contains(e)),
    ];

    return Material(
      elevation: 8,
      color: Colors.white,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: specs.length,
        separatorBuilder:
            (_, __) => Divider(height: 1, color: AppColors.secondary),
        itemBuilder: (_, i) {
          final spec = specs[i];
          final checked = ref.watch(filterProvider).contains(spec);
          return InkWell(
            onTap: () => ref.read(filterProvider.notifier).toggle(spec),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Paddings.l,
                vertical: Paddings.l,
              ),
              child: Row(
                children: [
                  Expanded(child: Label(spec)),
                  Checkbox(
                    value: checked,
                    onChanged:
                        (_) => ref.read(filterProvider.notifier).toggle(spec),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
