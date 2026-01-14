import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/questionnaire_provider.dart';
import 'summary_page.dart';
import '../../domain/entities/question.dart' as entity;

class ScreeningPage extends ConsumerWidget {
  const ScreeningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(questionnaireProvider);
    final questions = ref.watch(questionsProvider);

    final totalQuestions = questions.length;
    final answeredCount = state.answers.length;
    final progressValue = (totalQuestions == 0) ? 0.0 : answeredCount / totalQuestions;

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('Screening InsightMind'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.indigo.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$answeredCount / $totalQuestions pertanyaan terisi',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 10,
                    backgroundColor: Colors.indigo.shade200,
                    color: Colors.indigo.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Question list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final q = questions[index];
                final selectedScore = state.answers[q.id];

                return QuestionTile(
                  question: q,
                  selectedScore: selectedScore,
                  onSelected: (score) {
                    ref
                        .read(questionnaireProvider.notifier)
                        .selectAnswer(questionId: q.id, score: score);
                  },
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            onPressed: () {
              if (!state.isComplete) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lengkapi semua pertanyaan dulu...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SummaryPage()),
              );
            },
            child: const Text(
              'Lihat Ringkasan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionTile extends StatelessWidget {
  final entity.Question question;
  final int? selectedScore;
  final void Function(int score) onSelected;

  const QuestionTile({
    super.key,
    required this.question,
    required this.selectedScore,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                for (final opt in question.options)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: selectedScore == opt.score
                          ? Colors.indigo.shade100
                          : Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selectedScore == opt.score
                            ? Colors.indigo
                            : Colors.indigo.shade200,
                      ),
                    ),
                    child: RadioListTile<int>(
                      title: Text(
                        opt.label,
                        style: TextStyle(
                          color: selectedScore == opt.score
                              ? Colors.indigo.shade900
                              : Colors.black87,
                        ),
                      ),
                      value: opt.score,
                      groupValue: selectedScore,
                      activeColor: Colors.indigo,
                      onChanged: (value) {
                        if (value != null) onSelected(value);
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
