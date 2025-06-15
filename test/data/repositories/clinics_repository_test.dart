import 'package:flutter_test/flutter_test.dart';
import 'package:pet_map/data/datasources/local_clinic_ds.dart';
import 'package:pet_map/data/datasources/remote_clinic_ds.dart';
import 'package:pet_map/data/repositories/clinics_repository_impl.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class FakeRemoteClinicDS extends RemoteClinicDS {
  @override
  Future<List<VetClinic>> search(Point _, double __) async => [
    VetClinic(
      id: '1',
      name: 'Test Vet',
      point: const Point(latitude: 59.9343, longitude: 30.3351),
    ),
  ];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  test('repository emits clinics from remote', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    final local = LocalClinicDS();
    await local.init();

    final repo = ClinicsRepositoryImpl(FakeRemoteClinicDS(), local);

    final first = repo.watchClinics().first;

    await repo.getNearby(
      const Point(latitude: 59.9, longitude: 30.3),
      radiusMeters: 5000,
    );

    final list = await first;
    expect(list.length, 1);
  });
}
