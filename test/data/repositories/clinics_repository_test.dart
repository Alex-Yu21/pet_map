import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/data/datasources/local_clinic_ds.dart';
import 'package:pet_map/data/repositories/clinics_repository_impl.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('shoud emits clinics from local storage', () async {
    final local = LocalClinicDS();
    await local.init();

    final clinic = VetClinic(
      id: '1',
      name: 'Test Vet',
      point: const LatLng(59.9343, 30.3351),
    );
    await local.addCustom(clinic);

    final repo = ClinicsRepositoryImpl(local);

    final firstEmission = repo.watchClinics().first;

    await repo.getNearby(const LatLng(59.9, 30.3), radiusMeters: 5000);

    final clinics = await firstEmission;
    expect(clinics.length, 1);
    expect(clinics.first.id, '1');
  });
}
