import 'package:geolocator/geolocator.dart';

class StreamPosition {
  StreamPosition(this._provider);
  final Stream<Position> Function() _provider;

  Stream<Position> call() => _provider();
}
