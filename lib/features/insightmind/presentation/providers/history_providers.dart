import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ===============================
/// MODEL: Riwayat Hasil Screening
/// ===============================
class HistoryRecord {
  final int score;
  final String riskLevel;
  final DateTime timestamp;

  HistoryRecord({
    required this.score,
    required this.riskLevel,
    required this.timestamp,
  });
}

/// ===============================
/// REPOSITORY (Source of Truth)
/// ===============================
class HistoryRepository {
  final List<HistoryRecord> _records = [];

  /// Simpan hasil screening
  Future<void> addRecord({
    required int score,
    required String riskLevel,
  }) async {
    // simulasi async (siap diganti DB / SQLite / Firebase)
    await Future.delayed(const Duration(milliseconds: 150));

    _records.add(
      HistoryRecord(
        score: score,
        riskLevel: riskLevel,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Ambil semua histori
  List<HistoryRecord> getAll() {
    return List.unmodifiable(_records);
  }
}

/// ===============================
/// PROVIDERS (Riverpod 2.x)
/// ===============================

/// Repository provider
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

/// Provider untuk Dashboard (async-safe)
final historyListProvider =
    FutureProvider<List<HistoryRecord>>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.getAll();
});
