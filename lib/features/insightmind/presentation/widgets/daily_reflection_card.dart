import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reflection_provider.dart';

class DailyReflectionCard extends ConsumerWidget {
  const DailyReflectionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check-in Reflektif Hari Ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Apa yang paling menguras energimu hari ini?',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: reflectionOptions.map((option) {
                return OutlinedButton(
                  onPressed: () {
                    ref.read(reflectionProvider.notifier).submit(option);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Terima kasih sudah merefleksikan harimu 🌱',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
