import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insightmind_app/features/insightmind/data/models/feature_vector.dart';
import '../providers/sensors_provider.dart';
import '../providers/ppg_provider.dart';
import '../providers/score_provider.dart';
import 'ai_result_page.dart';

class BiometricPage extends ConsumerWidget {
  const BiometricPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accelFeat = ref.watch(accelFeatureProvider);
    final ppg = ref.watch(ppgProvider);
    final score = ref.watch(scoreProvider);

    /// =======================
    /// KONDISI TOMBOL AI
    /// =======================
    final bool canPredict =
        accelFeat.isStable && ppg.samples.length >= 30;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Sensor & Biometrik"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEEF2FF),
              Color(0xFFE0E7FF),
              Color(0xFFF5F3FF),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          children: [
            _SectionTitle(
              icon: Icons.directions_run,
              title: "Accelerometer",
            ),
            _GlassCard(
              child: Column(
                children: [
                  _MetricTile(
                    label: "Mean",
                    value: accelFeat.mean.toStringAsFixed(4),
                  ),
                  _MetricTile(
                    label: "Variance",
                    value: accelFeat.variance.toStringAsFixed(4),
                  ),
                  const SizedBox(height: 12),

                  /// ===== STATUS SENSOR =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        accelFeat.isStable
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        color: accelFeat.isStable
                            ? Colors.green
                            : Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        accelFeat.isStable
                            ? "Sensor Stabil"
                            : "Sensor Bergerak",
                        style: TextStyle(
                          color: accelFeat.isStable
                              ? Colors.green
                              : Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            _SectionTitle(
              icon: Icons.favorite,
              title: "PPG via Kamera",
            ),
            _GlassCard(
              child: Column(
                children: [
                  _MetricTile(
                    label: "Mean Y",
                    value: ppg.mean.toStringAsFixed(6),
                  ),
                  _MetricTile(
                    label: "Variance Y",
                    value: ppg.variance.toStringAsFixed(6),
                  ),
                  _MetricTile(
                    label: "Samples",
                    value: ppg.samples.length.toString(),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      final notifier =
                          ref.read(ppgProvider.notifier);
                      ppg.capturing
                          ? notifier.stopCapture()
                          : notifier.startCapture();
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: ppg.capturing
                              ? [Colors.redAccent, Colors.deepOrange]
                              : const [
                                  Color(0xFF6366F1),
                                  Color(0xFF8B5CF6),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            ppg.capturing
                                ? Icons.stop
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ppg.capturing
                                ? "Stop Capture"
                                : "Start Capture",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Progress Sampel PPG",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (ppg.samples.length / 30)
                              .clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor:
                              Colors.grey.shade300,
                          valueColor:
                              const AlwaysStoppedAnimation(
                                  Colors.deepPurple),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${ppg.samples.length} / 30 sampel",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// =========================
            /// TOMBOL AI (AUTO DISABLE)
            /// =========================
            GestureDetector(
              onTap: canPredict
                  ? () {
                      final fv = FeatureVector(
                        screeningScore: score.toDouble(),
                        activityMean: accelFeat.mean,
                        activityVar: accelFeat.variance,
                        ppgMean: ppg.mean,
                        ppgVar: ppg.variance,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AIResultPage(fv: fv),
                        ),
                      );
                    }
                  : () {
                      String msg = "";

                      if (!accelFeat.isStable) {
                        msg =
                            "Sensor harus stabil sebelum analisis AI";
                      } else {
                        msg =
                            "Ambil minimal 30 sampel PPG dahulu";
                      }

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(content: Text(msg)),
                      );
                    },
              child: AnimatedContainer(
                duration:
                    const Duration(milliseconds: 250),
                height: 58,
                decoration: BoxDecoration(
                  gradient: canPredict
                      ? const LinearGradient(
                          colors: [
                            Color(0xFF7C3AED),
                            Color(0xFF9333EA),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.grey.shade400,
                            Colors.grey.shade500,
                          ],
                        ),
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: canPredict
                      ? const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insights,
                      color: canPredict
                          ? Colors.white
                          : Colors.black38,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Hitung Prediksi AI",
                      style: TextStyle(
                        color: canPredict
                            ? Colors.white
                            : Colors.black38,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================== WIDGET PENDUKUNG ================== */

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
