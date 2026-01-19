import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/history_providers.dart';
import '../providers/report_provider.dart';


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

  final uri = Uri.parse(
    'https://wa.me/?text=${Uri.encodeComponent(message)}',
  );

  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);

    final reportState = ref.watch(reportProvider);
    final reportNotifier = ref.read(reportProvider.notifier);

    ref.listen(reportProvider, (previous, next) {
      if (previous?.reportFile == null &&
          next.reportFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Laporan PDF berhasil disimpan'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

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
                'Terdapat kecenderungan risiko tinggi. Pertimbangkan relaksasi atau konsultasi.';
          } else if (sedang > rendah) {
            insight =
                'Risiko berada pada tingkat sedang dan perlu dipantau.';
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _SummaryCard(
                tinggi: tinggi,
                sedang: sedang,
                rendah: rendah,
              ),
              const SizedBox(height: 24),
              _TrendCard(records: records),
              const SizedBox(height: 24),
              _InsightCard(
                insight: insight,
                tinggi: tinggi,
                sedang: sedang,
                rendah: rendah,
                reportState: reportState,
                reportNotifier: reportNotifier,
              ),
            ],
          );
        },
      ),
    );
  }
}

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
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali ke Home'),
          ),
        ],
      ),
    );
  }
}

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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd/MM/yyyy')
                    .format(records.first.timestamp)),
                Text(DateFormat('dd/MM/yyyy')
                    .format(records.last.timestamp)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String insight;
  final int tinggi;
  final int sedang;
  final int rendah;
  final ReportState reportState;
  final ReportNotifier reportNotifier;

  const _InsightCard({
    required this.insight,
    required this.tinggi,
    required this.sedang,
    required this.rendah,
    required this.reportState,
    required this.reportNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Insight:\n$insight'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Tinggi: $tinggi')),
                Chip(label: Text('Sedang: $sedang')),
                Chip(label: Text('Rendah: $rendah')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF'),
                    onPressed: () {
                      reportNotifier.generateReport(
                        userName: 'Anita Sari',
                        age: 21,
                        date: DateFormat('dd MMM yyyy')
                            .format(DateTime.now()),
                        stressScore: tinggi.toDouble(),
                        moodScore: sedang.toDouble(),
                        conclusion: insight,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
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