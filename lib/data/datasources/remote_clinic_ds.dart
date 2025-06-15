import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../domain/entities/vet_clinic.dart';

class RemoteClinicDS {
  Future<List<VetClinic>> search(Point center, double radiusMeters) async {
    final geometry = Geometry.fromCircle(
      Circle(center: center, radius: radiusMeters),
    );

    const options = SearchOptions(
      searchType: SearchType.biz,
      resultPageSize: 50,
      geometry: true,
    );

    final (_, future) = await YandexSearch.searchByText(
      searchText: 'ветеринарная клиника',
      geometry: geometry,
      searchOptions: options,
    );

    final result = await future;
    debugPrint('▶ YandexSearch items = ${result.items?.length ?? 0}');

    return (result.items ?? []).where((i) => i.geometry.isNotEmpty == true).map(
      (i) {
        final point = i.geometry.first.point!;
        return VetClinic(
          id: '${point.latitude}_${point.longitude}',
          name: i.name,
          point: point,
          address: null,
          phone: null,
        );
      },
    ).toList();
  }
}
