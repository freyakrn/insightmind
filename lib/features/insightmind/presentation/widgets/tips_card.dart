import 'package:flutter/material.dart';
import '../../data/tips_data.dart';
import '../pages/tips_detail_page.dart';

class TipsCard extends StatelessWidget {
  const TipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final index = today.day % dailyTips.length;
    final tip = dailyTips[index];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lightbulb, color: Colors.amber, size: 28),
              SizedBox(width: 8),
              Text(
                'Tips Hari Ini',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            tip.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            tip.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15),
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TipsDetailPage(tip: tip),
                  ),
                );
              },
              child: const Text('Selengkapnya >'),
            ),
          ),
        ],
      ),
    );
  }
}
