import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/history_providers.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  Color _riskColor(String level) {
    switch (level) {
      case 'Tinggi':
        return Colors.red.shade400;
      case 'Sedang':
        return Colors.orange.shade400;
      default:
        return Colors.green.shade400;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Screening'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo.shade50,
      body: historyAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Terjadi kesalahan: $e'),
        ),
        data: (history) {
          if (history.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat screening.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final color = _riskColor(item.riskLevel);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.15),
                    child: Icon(Icons.favorite, color: color),
                  ),
                  title: Text(
                    'Skor: ${item.score}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Risiko: ${item.riskLevel}',
                    style: TextStyle(color: color),
                  ),
                  trailing: Text(
                    DateFormat('dd MMM yyyy').format(item.timestamp),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
