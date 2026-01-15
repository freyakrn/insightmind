import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pilihan refleksi
const reflectionOptions = [
  'Pekerjaan / Kuliah',
  'Hubungan',
  'Kesehatan',
  'Pikiran sendiri',
  'Tidak tahu',
];

/// State: Map<kategori, jumlah>
class ReflectionNotifier extends StateNotifier<Map<String, int>> {
  ReflectionNotifier() : super({});

  void submit(String value) {
    state = {
      ...state,
      value: (state[value] ?? 0) + 1,
    };
  }
}

final reflectionProvider =
    StateNotifierProvider<ReflectionNotifier, Map<String, int>>(
  (ref) => ReflectionNotifier(),
);
