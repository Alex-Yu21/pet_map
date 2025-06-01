import 'package:flutter/material.dart';
import 'package:pet_map/presentation/map_page.dart';

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
      home: MapPage(),
    );
  }
}
