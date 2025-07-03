import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/data/datasources/local_clinic_ds.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late LocalClinicDS ds;

  setUp(() async {
    ds = LocalClinicDS();
    await ds.init();
  });

  test('addCustom persists clinic', () async {
    final clinic = VetClinic(id: '1', name: 'Name', point: const LatLng(1, 2));
    await ds.addCustom(clinic);
    final list = ds.customClinics();
    expect(list.length, 1);
    expect(list.first.id, '1');
  });

  test('toggle hides and unhides clinic', () async {
    const id = '1';
    await ds.toggle(id);
    expect(ds.isHidden(id), true);
    await ds.toggle(id);
    expect(ds.isHidden(id), false);
  });
}
