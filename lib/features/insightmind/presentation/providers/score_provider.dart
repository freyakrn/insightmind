import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insightmind_app/features/insightmind/domain/entities/mental_result.dart';
import '../../../insightmind/domain/usecases/calculate_risk_level.dart';
import '../../../insightmind/data/repositories/score_repository.dart';
import 'questionnaire_provider.dart';

final scoreRepositoryProvider = Provider<ScoreRepository>((ref) {
  return ScoreRepository();
});

final calculateRiskProvider = Provider<CalculateRiskLevel>((ref) {
  return CalculateRiskLevel();
});

/// Skor total diambil dari questionnaireProvider
final scoreProvider = Provider<int>((ref) {
  final repo = ref.watch(scoreRepositoryProvider);
  final questionnaire = ref.watch(questionnaireProvider);
  final answersList = questionnaire.answers.values.toList();
  return repo.calculateScore(answersList);
});

/// Hasil akhir (MentalResult)
final resultProvider = Provider<MentalResult>((ref) {
  final score = ref.watch(scoreProvider);
  final usecase = ref.watch(calculateRiskProvider);
  return usecase.execute(score);
});
