import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_map/presentation/providers/nav_ui_providers.dart';
import 'package:pet_map/presentation/providers/pets_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/pets_list_view/widgets/add_button.dart';
import 'package:pet_map/presentation/views/pets_list_view/widgets/pet_card.dart';

class PetsListView extends ConsumerStatefulWidget {
  const PetsListView({super.key});

  @override
  ConsumerState<PetsListView> createState() => _PetsListViewState();
}

class _PetsListViewState extends ConsumerState<PetsListView> {
  void _hide() => ref.read(navBarShadowProvider.notifier).state = false;
  void _show() => ref.read(navBarShadowProvider.notifier).state = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hide());
  }

  @override
  void dispose() {
    _show();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(petsProvider);

    return petsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (pets) {
        if (pets.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(Paddings.l),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(height: 60.h), const AddButton()],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(Paddings.l),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => PetCard(pet: pets[i]),
                  childCount: pets.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  left: Paddings.l,
                  right: Paddings.l,
                  bottom: Paddings.l,
                ),
                child: const Center(child: AddButton()),
              ),
            ),
          ],
        );
      },
    );
  }
}
