import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/data/datasources/local_clinic_ds.dart';
import 'package:pet_map/data/repositories/clinics_repository_impl.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('getNearby emits clinics respecting hidden', () async {
    final ds = LocalClinicDS();
    await ds.init();
    final clinic = VetClinic(id: '1', name: 'A', point: const LatLng(0, 0));
    await ds.addCustom(clinic);
    await ds.toggle('1');

    final repo = ClinicsRepositoryImpl(ds);
    final firstEmission = repo.watchClinics().first;
    await repo.getNearby(const LatLng(0, 0));
    final list = await firstEmission;
    expect(list.first.visible, false);
  });

  test('toggleVisibility updates stream', () async {
    final ds = LocalClinicDS();
    await ds.init();
    final clinic = VetClinic(id: '1', name: 'A', point: const LatLng(0, 0));
    await ds.addCustom(clinic);

    final repo = ClinicsRepositoryImpl(ds);
    await repo.getNearby(const LatLng(0, 0));
    final updated = repo.watchClinics().skip(1).first;
    await repo.toggleVisibility('1');
    final list = await updated;
    expect(list.first.visible, false);
  });
}
