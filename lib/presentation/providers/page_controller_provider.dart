import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navIndexProvider = StateProvider<int>((_) => 0);

final pageCtrlProvider = Provider<PageController>(
  (_) => PageController(initialPage: 0),
);
