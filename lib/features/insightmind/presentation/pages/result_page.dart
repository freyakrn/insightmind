import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/score_provider.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/history_providers.dart';

class ResultPage extends ConsumerStatefulWidget {
  const ResultPage({super.key});

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  bool _saved = false; // FLAG agar autosave tidak dobel saat rebuild

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Autosave 1x ketika halaman pertama kali siap
    if (!_saved) {
      final result = ref.read(resultProvider);
      _saveResult(result.score, result.riskLevel);
      _saved = true;
    }
  }

  Future<void> _saveResult(int score, String riskLevel) async {
    await ref
        .read(historyRepositoryProvider)
        .addRecord(score: score, riskLevel: riskLevel);

    // Refresh dashboard / history listener
    ref.refresh(historyListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(resultProvider);
    final questionnaire = ref.watch(questionnaireProvider);

    final totalScore = result.score;
    final riskLevel = result.riskLevel;

    late String recommendation;
    late Color riskColor;

    switch (riskLevel) {
      case 'Tinggi':
        riskColor = Colors.red;
        recommendation =
            '⚠️ Tingkat risiko Anda tinggi. Disarankan segera berkonsultasi dengan profesional seperti konselor atau psikolog kampus.';
        break;
      case 'Sedang':
        riskColor = Colors.orange;
        recommendation =
            '😐 Anda berada pada tingkat risiko sedang. Cobalah rutinitas penenang seperti olahraga ringan, meditasi, atau tidur yang cukup.';
        break;
      default:
        riskColor = Colors.green;
        recommendation =
            '😊 Risiko Anda rendah. Pertahankan gaya hidup sehat seperti tidur cukup, makan teratur, dan tetap aktif.';
        break;
    }

    final totalQuestions = questionnaire.answers.length;
    final maxScore = totalQuestions * 3;
    final progressValue = (maxScore == 0) ? 0.0 : totalScore / maxScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Screening Kesehatan Mental'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              '🧠 Hasil Analisis Anda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Progress bar
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progressValue.clamp(0.0, 1.0),
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: riskColor,
                    ),
                  ),
                ),
                Text(
                  '$totalScore / $maxScore',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            Text(
              'Tingkat Risiko Anda:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              riskLevel,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: riskColor,
              ),
            ),

            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '💡 Rekomendasi:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade900,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              recommendation,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),

            const Spacer(),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            const Text(
              'Disclaimer:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'InsightMind hanya bersifat edukatif dan tidak menggantikan diagnosis medis profesional.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // ===== BUTTON ULANGI SCREENING =====
            ElevatedButton.icon(
              onPressed: () {
                // reset kuisioner
                ref.read(questionnaireProvider.notifier).reset();

                // kembali ke halaman utama
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.restart_alt, color: Colors.white),
              label: const Text(
                'Ulangi Screening',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
