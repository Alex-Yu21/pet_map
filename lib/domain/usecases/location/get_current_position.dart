import 'package:geolocator/geolocator.dart';

class GetCurrentPosition {
  GetCurrentPosition(this._provider);
  final Future<Position> Function() _provider;

  Future<Position> call() => _provider();
}
