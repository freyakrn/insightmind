import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/history_providers.dart';
import '../providers/reflection_provider.dart';

import '../widgets/daily_reflection_card.dart';
import '../widgets/reflection_trend_card.dart';

import 'pdf_preview_page.dart';

/// ===============================
/// SHARE INSIGHT TO WHATSAPP
/// ===============================
Future<void> shareInsightToWhatsApp({
  required String insight,
  required int tinggi,
  required int sedang,
  required int rendah,
}) async {
  final message = '''
🧠 *InsightMind – Laporan Kesehatan Mental*

📊 *Ringkasan Risiko*
🔴 Tinggi  : $tinggi
🟠 Sedang : $sedang
🟢 Rendah : $rendah

📌 *Insight*
$insight

_Dihasilkan oleh InsightMind_
''';

  final uri =
      Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');

  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// ===============================
/// DASHBOARD PAGE
/// ===============================
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);
    final reflectionTrend = ref.watch(reflectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('InsightMind Dashboard'),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Terjadi kesalahan: $e')),
        data: (records) {
          if (records.isEmpty) {
            return const _EmptyState();
          }

          final tinggi =
              records.where((r) => r.riskLevel == 'Tinggi').length;
          final sedang =
              records.where((r) => r.riskLevel == 'Sedang').length;
          final rendah =
              records.where((r) => r.riskLevel == 'Rendah').length;

          String insight = 'Kondisi mental relatif stabil.';
          if (tinggi > sedang && tinggi > rendah) {
            insight =
                'Terdapat kecenderungan risiko tinggi. Pertimbangkan relaksasi atau konsultasi profesional.';
          } else if (sedang > rendah) {
            insight = 'Risiko berada pada tingkat sedang dan perlu dipantau.';
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              /// 🔹 RINGKASAN RISIKO
              _SummaryCard(
                tinggi: tinggi,
                sedang: sedang,
                rendah: rendah,
              ),

              const SizedBox(height: 24),

              /// 🔹 CHECK-IN REFLEKTIF
              const DailyReflectionCard(),

              const SizedBox(height: 24),

              /// 🔹 TREN REFLEKSI
              ReflectionTrendCard(trend: reflectionTrend),

              const SizedBox(height: 24),

              /// 🔹 TREN SKOR SCREENING
              _TrendCard(records: records),

              const SizedBox(height: 24),

              /// 🔹 INSIGHT + EXPORT
              _InsightCard(
                insight: insight,
                tinggi: tinggi,
                sedang: sedang,
                rendah: rendah,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// ===============================
/// EMPTY STATE
/// ===============================
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 64, color: Colors.indigo.shade200),
          const SizedBox(height: 16),
          const Text(
            'Belum ada data analytics.\nLakukan screening terlebih dahulu.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// SUMMARY CARD (FIXED)
/// ===============================
class _SummaryCard extends StatelessWidget {
  final int tinggi;
  final int sedang;
  final int rendah;

  const _SummaryCard({
    required this.tinggi,
    required this.sedang,
    required this.rendah,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Risiko',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('🔴 Tinggi  : $tinggi'),
            Text('🟠 Sedang : $sedang'),
            Text('🟢 Rendah : $rendah'),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// TREND CARD (SPARKLINE)
/// ===============================
class _TrendCard extends StatelessWidget {
  final List records;
  const _TrendCard({required this.records});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tren Skor Screening',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: _Sparkline(records: records)),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// INSIGHT CARD
/// ===============================
class _InsightCard extends StatelessWidget {
  final String insight;
  final int tinggi;
  final int sedang;
  final int rendah;

  const _InsightCard({
    required this.insight,
    required this.tinggi,
    required this.sedang,
    required this.rendah,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insight',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(insight),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Unduh PDF'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfPreviewPage(
                            insight: insight,
                            tinggi: tinggi,
                            sedang: sedang,
                            rendah: rendah,
                            nama: 'Yaya',
                            umur: 21,
                            tanggalLahir: '01 Januari 2002',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => shareInsightToWhatsApp(
                      insight: insight,
                      tinggi: tinggi,
                      sedang: sedang,
                      rendah: rendah,
                    ),
                    child: const Text('WA'),
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

/// ===============================
/// SPARKLINE
/// ===============================
class _Sparkline extends StatelessWidget {
  final List records;
  const _Sparkline({required this.records});

  @override
  Widget build(BuildContext context) {
    final values =
        records.map<double>((e) => (e.score as num).toDouble()).toList();

    if (values.length < 2) {
      return const Center(child: Text('Data belum cukup'));
    }

    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _SparklinePainter(values),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  _SparklinePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = (max - min) == 0 ? 1 : (max - min);

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y =
          size.height - ((values[i] - min) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
