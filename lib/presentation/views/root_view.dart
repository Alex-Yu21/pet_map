import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_map/presentation/providers/nav_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/map_view/map_view.dart';
import 'package:pet_map/presentation/views/pets_view/pets_view.dart';

final _navKeys = [GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];

class RootView extends ConsumerWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);

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
                    (_) => MaterialPageRoute(builder: (_) => const PetsView()),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            height: 64,
            selectedIndex: index,
            onDestinationSelected:
                (i) => ref.read(navIndexProvider.notifier).state = i,
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/icons/map.svg',
                  width: IconSizes.l,
                ),
                label: 'карта',
                selectedIcon: SvgPicture.asset(
                  'assets/icons/map_pressed.svg',
                  width: IconSizes.l,
                ),
              ),
              NavigationDestination(
                icon: Icon(Icons.pets_outlined, size: IconSizes.l),
                label: 'питомцы',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
