import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_map/presentation/providers/nav_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/map_view/map_view.dart';
import 'package:pet_map/presentation/views/pets_view/pets_view.dart';

class RootView extends ConsumerStatefulWidget {
  const RootView({super.key});

  @override
  ConsumerState<RootView> createState() => _RootViewState();
}

class _RootViewState extends ConsumerState<RootView> {
  final _navKeys = [GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];

  @override
  Widget build(BuildContext context) {
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
                    (settings) =>
                        MaterialPageRoute(builder: (_) => const MapView()),
              ),
              Navigator(
                key: _navKeys[1],
                onGenerateRoute:
                    (settings) =>
                        MaterialPageRoute(builder: (_) => const PetsView()),
              ),
            ],
          ),
          bottomNavigationBar: _BottomBar(index: index),
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  final int index;
  const _BottomBar({required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.grey.shade300,
        backgroundColor: const Color(0xFFF3F3F3),
      ),
      child: NavigationBar(
        selectedIndex: index,
        onDestinationSelected:
            (i) => ref.read(navIndexProvider.notifier).state = i,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.star_border, size: IconSizes.l),
            label: 'Карта',
            selectedIcon: SvgPicture.asset(
              'assets/icons/star_pressed.svg',
              width: IconSizes.l,
            ),
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border, size: IconSizes.l),
            label: 'Питомцы',
            selectedIcon: SvgPicture.asset(
              'assets/icons/star_pressed.svg',
              width: IconSizes.l,
            ),
          ),
        ],
      ),
    );
  }
}
