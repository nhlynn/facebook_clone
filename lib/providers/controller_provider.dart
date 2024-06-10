import 'package:flutter_riverpod/flutter_riverpod.dart';

final controllerProvider = StateProvider<int>((ref) {
  return 1; // Initial value
});