import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../data/datasources/local_clinic_ds.dart';
import '../../data/repositories/clinics_repository_impl.dart';
import '../../domain/entities/vet_clinic.dart';
import '../../domain/usecases/clinics/add_clinic.dart';
import '../../domain/usecases/clinics/get_nearby_clinics.dart';
import '../../domain/usecases/clinics/visibility.dart';

final _localDSProvider = Provider<LocalClinicDS>((ref) {
  final ds = LocalClinicDS()..init();
  return ds;
});

final _repoProvider = Provider<ClinicsRepositoryImpl>(
  (ref) => ClinicsRepositoryImpl(ref.read(_localDSProvider)),
);

final clinicsStreamProvider = StreamProvider<List<VetClinic>>(
  (ref) => ref.read(_repoProvider).watchClinics(),
);

final nearbyClinicsProvider = FutureProvider.autoDispose
    .family<List<VetClinic>, Point>((ref, point) {
      final uc = GetNearbyClinics(ref.read(_repoProvider));
      return uc(point);
    });

final addClinicProvider = Provider<AddClinic>(
  (ref) => AddClinic(ref.read(_repoProvider)),
);

final toggleClinicProvider = Provider<ToggleVisibility>(
  (ref) => ToggleVisibility(ref.read(_repoProvider)),
);
