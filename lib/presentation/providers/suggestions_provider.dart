import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';

import 'clinic_providers.dart';
import 'search_provider.dart';

final suggestionsProvider = Provider<List<VetClinic>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final clinics = ref.watch(clinicsStreamProvider).asData?.value ?? [];
  if (query.isEmpty) return [];
  return clinics
      .where((c) => c.name.toLowerCase().contains(query))
      .take(5)
      .toList();
});
