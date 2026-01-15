import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/questionnaire_provider.dart';
import 'result_page.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final questionnaire = ref.watch(questionnaireProvider);
    final answersMap = questionnaire.answers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Jawaban'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🧾 Berikut ringkasan jawaban Anda sebelum hasil akhir ditampilkan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  final userAnswerScore = answersMap[q.id];

                  if (userAnswerScore == null) return const SizedBox.shrink();

                  final selectedOption = q.options.firstWhere(
                    (opt) => opt.score == userAnswerScore,
                    orElse: () => q.options.first,
                  );

                  Color riskColor;
                  IconData riskIcon;
                  if (userAnswerScore >= 3) {
                    riskColor = Colors.red.shade100;
                    riskIcon = Icons.warning_amber_rounded;
                  } else if (userAnswerScore == 2) {
                    riskColor = Colors.orange.shade100;
                    riskIcon = Icons.error_outline;
                  } else {
                    riskColor = Colors.green.shade100;
                    riskIcon = Icons.check_circle_outline;
                  }

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: riskColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: userAnswerScore >= 3
                            ? Colors.red
                            : (userAnswerScore == 2 ? Colors.orange : Colors.green),
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        riskIcon,
                        color: userAnswerScore >= 3
                            ? Colors.red
                            : (userAnswerScore == 2 ? Colors.orange : Colors.green),
                        size: 26,
                      ),
                      title: Text(
                        q.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Jawaban: ${selectedOption.label}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.assessment_rounded, color: Colors.white),
                label: const Text(
                  'Lihat Hasil Akhir',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResultPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
