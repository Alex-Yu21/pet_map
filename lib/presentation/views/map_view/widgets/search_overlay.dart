import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/presentation/providers/map_position_providers.dart';
import 'package:pet_map/presentation/providers/map_ui_providers.dart';
import 'package:pet_map/presentation/providers/search_provider.dart';
import 'package:pet_map/presentation/providers/suggestions_provider.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';

class SearchOverlay extends ConsumerWidget {
  final double topOffset;
  const SearchOverlay({super.key, required this.topOffset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(suggestionsProvider);
    final query = ref.watch(searchQueryProvider).trim();
    if (query.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: topOffset,
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        color: Colors.white,
        child:
            suggestions.isEmpty
                ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'К сожалению по вашему запросу\nничего не найдено',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FontSizes.description,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: Paddings.l),
                      Image.asset(
                        'assets/images/not_found.png',
                        width: 160.w,
                        height: 160.w,
                      ),
                    ],
                  ),
                )
                : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: suggestions.length,
                  separatorBuilder:
                      (_, __) =>
                          Container(height: 1, color: AppColors.secondary),
                  itemBuilder: (_, i) {
                    final c = suggestions[i];
                    return InkWell(
                      onTap: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                        ref
                            .read(lastCameraPositionProvider.notifier)
                            .state = CameraPosition(target: c.point, zoom: 16);
                        ref
                            .read(mapCtrlProvider)
                            ?.animateCamera(CameraUpdate.newLatLng(c.point));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Paddings.l,
                          vertical: Paddings.s,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Label(c.name),
                            if (c.address != null)
                              Padding(
                                padding: EdgeInsets.only(top: Paddings.xs),
                                child: Text(
                                  c.address!,
                                  style: TextStyle(
                                    fontSize: FontSizes.description,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
