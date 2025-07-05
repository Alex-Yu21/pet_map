import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../di/app_providers.dart';
import '../../domain/entities/vet_clinic.dart';
import '../../domain/usecases/clinics/add_clinic.dart';
import '../../domain/usecases/clinics/visibility.dart';
import 'filter_provider.dart';
import 'search_provider.dart';

final clinicsStreamProvider = StreamProvider<List<VetClinic>>(
  (ref) => ref.read(clinicsRepositoryProvider).watchClinics(),
);

final filteredClinicsProvider = Provider<AsyncValue<List<VetClinic>>>((ref) {
  final clinics = ref.watch(clinicsStreamProvider);
  final filter = ref.watch(filterProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  return clinics.whenData((list) {
    var result = list.where((c) => c.visible).toList();

    if (filter.isNotEmpty) {
      result =
          result
              .where((c) => filter.every(c.specializations.contains))
              .toList();
    }

    if (query.isNotEmpty) {
      result =
          result.where((c) => c.name.toLowerCase().contains(query)).toList();
    }

    return result;
  });
});

final nearbyClinicsProvider = FutureProvider.autoDispose
    .family<List<VetClinic>, LatLng>((ref, center) {
      return ref.read(clinicsRepositoryProvider).getNearby(center);
    });

final addClinicProvider = Provider<AddClinic>(
  (ref) => AddClinic(ref.read(clinicsRepositoryProvider)),
);

final toggleClinicProvider = Provider<ToggleVisibility>(
  (ref) => ToggleVisibility(ref.read(clinicsRepositoryProvider)),
);
