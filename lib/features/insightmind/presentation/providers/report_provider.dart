import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/report_generator.dart';

/// ===============================
/// PROVIDER INSTANCE
/// ===============================
final reportGeneratorProvider = Provider<ReportGenerator>((ref) {
  return ReportGenerator();
});

/// ===============================
/// STATE
/// ===============================
class ReportState {
  final bool isLoading;
  final File? reportFile;
  final String? errorMessage;

  const ReportState({
    this.isLoading = false,
    this.reportFile,
    this.errorMessage,
  });

  ReportState copyWith({
    bool? isLoading,
    File? reportFile,
    String? errorMessage,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      reportFile: reportFile ?? this.reportFile,
      errorMessage: errorMessage,
    );
  }
}

/// ===============================
/// NOTIFIER
/// ===============================
class ReportNotifier extends StateNotifier<ReportState> {
  final ReportGenerator reportGenerator;

  ReportNotifier(this.reportGenerator) : super(const ReportState());

  /// Generate laporan PDF InsightMind
  Future<void> generateReport({
    required String userName,
    required int age,
    required String date,
    required double stressScore,
    required double moodScore,
    required String conclusion,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final file = await reportGenerator.generateMentalReport(
        userName: userName,
        age: age,
        date: date,
        stressScore: stressScore,
        moodScore: moodScore,
        conclusion: conclusion,
      );

      state = state.copyWith(
        isLoading: false,
        reportFile: file,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal membuat laporan',
      );
    }
  }

  /// Reset state (opsional)
  void reset() {
    state = const ReportState();
  }
}

/// ===============================
/// STATE NOTIFIER PROVIDER
/// ===============================
final reportProvider =
    StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  final generator = ref.read(reportGeneratorProvider);
  return ReportNotifier(generator);
});
