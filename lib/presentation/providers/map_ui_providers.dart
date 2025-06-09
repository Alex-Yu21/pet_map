import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

final mapCtrlProvider = StateProvider<YandexMapController?>((_) => null);
