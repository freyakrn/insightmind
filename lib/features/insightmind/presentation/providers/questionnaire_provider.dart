import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/question.dart';

/// State: menyimpan jawaban dan index (optional)
class QuestionnaireState {
  final int currentIndex;
  final Map<String, int> answers;

  const QuestionnaireState({
    this.currentIndex = 0,
    this.answers = const {},
  });

  QuestionnaireState copyWith({
    int? currentIndex,
    Map<String, int>? answers,
  }) {
    return QuestionnaireState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
    );
  }

  /// Semua pertanyaan terisi?
  bool get isComplete => answers.length >= defaultQuestions.length;

  /// Total skor
  int get totalScore => answers.values.fold(0, (a, b) => a + b);
}

/// Notifier: mengatur jawaban & reset
class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  QuestionnaireNotifier() : super(const QuestionnaireState());

  /// Simpan jawaban untuk questionId (digunakan di ScreeningPage)
  void selectAnswer({required String questionId, required int score}) {
    final newAnswers = Map<String, int>.from(state.answers);
    newAnswers[questionId] = score;
    state = state.copyWith(answers: newAnswers);
  }

  /// Optional: jika kamu ingin otomatis maju index
  void answerAndNext({required String questionId, required int score}) {
    final newAnswers = Map<String, int>.from(state.answers);
    newAnswers[questionId] = score;
    final nextIndex = state.currentIndex + 1;
    state = state.copyWith(answers: newAnswers, currentIndex: nextIndex);
  }

  /// Reset semua jawaban dan index
  void reset() {
    state = const QuestionnaireState();
  }
}

/// Provider daftar pertanyaan (static)
final questionsProvider = Provider<List<Question>>((ref) {
  return defaultQuestions;
});

/// Provider state kuisioner
final questionnaireProvider =
    StateNotifierProvider<QuestionnaireNotifier, QuestionnaireState>(
  (ref) => QuestionnaireNotifier(),
);

class HistoryEntry {
  final int score;
  final String riskLevel;
  final String date;

  HistoryEntry({
    required this.score,
    required this.riskLevel,
    required this.date,
  });
}

final questionnaireHistoryProvider =
    StateNotifierProvider<QuestionnaireHistoryNotifier, List<HistoryEntry>>(
  (ref) => QuestionnaireHistoryNotifier(),
);

class QuestionnaireHistoryNotifier extends StateNotifier<List<HistoryEntry>> {
  QuestionnaireHistoryNotifier() : super([]);

  void add(int score, String level) {
    final now = DateTime.now();
    final formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}";

    final entry = HistoryEntry(
      score: score,
      riskLevel: level,
      date: formattedDate,
    );

    state = [entry, ...state]; // prepend
  }

  void clear() {
    state = [];
  }
}
