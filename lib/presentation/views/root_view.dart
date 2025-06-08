import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_map/presentation/providers/page_controller_provider.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/map_view/map_view.dart';

class RootView extends ConsumerWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    final ctrl = ref.watch(pageCtrlProvider);

    ref.listen<int>(navIndexProvider, (_, next) {
      ctrl.jumpToPage(next);
    });

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: PageView(
            controller: ctrl,
            physics: const NeverScrollableScrollPhysics(),
            children: const [MapView(), PetsView()],
          ),
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(backgroundColor: Color(0xFFF3F3F3)),
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
          ),
        ),
      ),
    );
  }
}

class PetsView extends StatelessWidget {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Pets'));
  }
}
