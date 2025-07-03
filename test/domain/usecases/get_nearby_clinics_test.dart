import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/data/datasources/local_clinic_ds.dart';
import 'package:pet_map/data/repositories/clinics_repository_impl.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/domain/usecases/clinics/get_nearby_clinics.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('GetNearbyClinics returns clinics from repo', () async {
    final ds = LocalClinicDS();
    await ds.init();
    final clinic = VetClinic(id: '1', name: 'A', point: const LatLng(1, 1));
    await ds.addCustom(clinic);

    final repo = ClinicsRepositoryImpl(ds);
    final uc = GetNearbyClinics(repo);
    final list = await uc(const LatLng(1, 1));
    expect(list.length, 1);
    expect(list.first.id, '1');
  });
}
