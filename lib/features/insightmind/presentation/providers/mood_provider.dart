import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MoodType {
  baik,
  tenang,
  cemas,
  lelah,
}

final moodProvider = StateProvider<MoodType?>((ref) {
  return null; // belum memilih mood
});
