// WEEK 7 – AI Risk Prediction (Modern & Complete UI)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insightmind_app/features/insightmind/data/models/feature_vector.dart';
import '../providers/ai_provider.dart';

class AIResultPage extends ConsumerWidget {
  final FeatureVector fv;
  const AIResultPage({super.key, required this.fv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(aiResultProvider(fv));

    final String level = result['riskLevel'];
    final double score = result['weightedScore'];
    final double confidence = result['confidence'];

    final Color riskColor = _riskColor(level);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Risk Prediction"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEEF2FF),
              Color(0xFFF5F3FF),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 24),
          children: [
            // ===== HEADER =====
            Column(
              children: const [
                Text(
                  "Hasil Analisis Risiko",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Dihitung menggunakan AI & sensor biometrik",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ===== MAIN RESULT CARD =====
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: riskColor.withOpacity(0.25),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "AI ANALYSIS RESULT",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Icon(
                    Icons.insights_rounded,
                    size: 64,
                    color: riskColor,
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Tingkat Risiko",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    level.toUpperCase(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== CONFIDENCE BAR =====
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Confidence AI",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: confidence,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade300,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(riskColor),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${(confidence * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Skor AI: ${score.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ===== SUMMARY CARD =====
            _InfoCard(
              title: "Ringkasan Faktor",
              items: [
                "Aktivitas tubuh: ${fv.activityVar > 0.05 ? "Tidak stabil" : "Stabil"}",
                "Variabilitas PPG: ${fv.ppgVar > 50 ? "Tinggi" : "Normal"}",
                "Skor screening: ${fv.screeningScore.toStringAsFixed(0)}",
              ],
            ),

            const SizedBox(height: 16),

            // ===== INSIGHT =====
            _InfoCard(
              title: "Insight AI",
              items: [
                level == "Tinggi"
                    ? "Risiko tinggi dapat dipengaruhi oleh aktivitas tubuh yang tidak stabil dan variabilitas detak jantung."
                    : "Data biometrik menunjukkan kondisi relatif terkendali.",
                "Disarankan melakukan pengukuran ulang dalam kondisi lebih rileks.",
              ],
            ),

            const SizedBox(height: 28),

            // ===== ACTION BUTTON =====
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.refresh),
              label: const Text("Ulangi Pengukuran"),
              style: ElevatedButton.styleFrom(
                backgroundColor: riskColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Kembali"),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                "Powered by InsightMind AI",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== HELPERS =====
  Color _riskColor(String level) {
    switch (level) {
      case "Tinggi":
        return Colors.redAccent;
      case "Sedang":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}

// ===== REUSABLE INFO CARD =====
class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const _InfoCard({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
