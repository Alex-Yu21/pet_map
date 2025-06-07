import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/presentation/views/root_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PetMapApp());
}

class PetMapApp extends StatelessWidget {
  const PetMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProviderScope(child: RootView()),
    );
  }
}
