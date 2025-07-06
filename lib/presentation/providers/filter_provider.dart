import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterNotifier extends StateNotifier<Set<String>> {
  FilterNotifier() : super(const <String>{});

  void toggle(String animal) {
    if (state.contains(animal)) {
      state = {...state}..remove(animal);
    } else {
      state = {...state, animal};
    }
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, Set<String>>(
  (_) => FilterNotifier(),
);
