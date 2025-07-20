import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_map/presentation/providers/nav_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/map_view/map_view.dart';
import 'package:pet_map/presentation/views/pets_list_view/pets_list_view.dart';

final _navKeys = [GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];

class RootView extends ConsumerWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    final showShadow = ref.watch(navBarShadowProvider);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: index,
            children: [
              Navigator(
                key: _navKeys[0],
                onGenerateRoute:
                    (_) => MaterialPageRoute(builder: (_) => const MapView()),
              ),
              Navigator(
                key: _navKeys[1],
                onGenerateRoute:
                    (_) =>
                        MaterialPageRoute(builder: (_) => const PetsListView()),
              ),
            ],
          ),
          bottomNavigationBar: Material(
            elevation: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow:
                    showShadow
                        ? [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.08 * 255).round()),
                            blurRadius: 8,
                            offset: const Offset(0, -4),
                          ),
                        ]
                        : [],
              ),
              child: NavigationBar(
                height: 64,
                selectedIndex: index,
                onDestinationSelected:
                    (i) => ref.read(navIndexProvider.notifier).state = i,
                destinations: [
                  NavigationDestination(
                    icon: _NavIconSvg('assets/icons/map.svg'),
                    selectedIcon: _NavIconSvg('assets/icons/map_pressed.svg'),
                    label: 'карта',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.pets_outlined, size: IconSizes.l),
                    label: 'питомцы',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIconSvg extends StatelessWidget {
  const _NavIconSvg(this.path);
  final String path;

  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset(path, width: IconSizes.l);
}
