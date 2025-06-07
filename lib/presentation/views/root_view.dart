import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/presentation/providers/page_controller_provider.dart';
import 'package:pet_map/presentation/views/map_view.dart';

class RootView extends ConsumerWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    final ctrl = ref.watch(pageCtrlProvider);

    ref.listen<int>(navIndexProvider, (_, next) {
      ctrl.jumpToPage(next);
    });

    return Scaffold(
      body: PageView(
        controller: ctrl,
        physics: const NeverScrollableScrollPhysics(),
        children: const [MapView(), PetsView()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected:
            (i) => ref.read(navIndexProvider.notifier).state = i,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.star_border), label: 'Карта'),
          NavigationDestination(
            icon: Icon(Icons.star_rounded),
            label: 'Питомцы',
          ),
        ],
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
