import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/history_providers.dart';
import '../providers/mood_provider.dart';
import 'screening_page.dart';
import 'biometric_page.dart';
import 'dashboard_page.dart';
import '../widgets/tips_card.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF6E5), // warm cream
              Color(0xFFF3E8FF), // soft lavender
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Terjadi kesalahan: $e')),
          data: (records) {
            final lastScore =
                records.isNotEmpty ? records.last.score : 0;

            return CustomScrollView(
              slivers: [
                _HeroAppBar(score: lastScore),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 8),

                      _InsightCard(score: lastScore),
                      const SizedBox(height: 24),
                      const _QuickMoodSection(),
                      const SizedBox(height: 28),

                      const _SectionTitle(
                        title: 'Menu Utama',
                        subtitle: 'Pantau kondisi mental dan biometrik Anda',
                      ),

                      const SizedBox(height: 16),

                      _FeatureTile(
                        icon: Icons.assignment_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A7BFF), Color(0xFF8FA1FF)],
                        ),
                        title: '📝 Screening Psikologis',
                        description:
                            'Jawab kuisioner singkat untuk mendapatkan indikasi awal '
                            'kondisi kesehatan mental Anda.',
                        primaryLabel: 'Mulai Screening',
                        secondaryLabel: 'Dashboard',
                        onPrimary: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ScreeningPage(),
                          ),
                        ),
                        onSecondary: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardPage(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _FeatureTile(
                        icon: Icons.sensors_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C6A2), Color(0xFF00E0B8)],
                        ),
                        title: '📡 Sensor & AI Biometrik',
                        description:
                            'Gunakan kamera dan sensor perangkat untuk ekstraksi '
                            'fitur biometrik dan prediksi risiko berbasis AI.',
                        primaryLabel: 'Buka Modul AI',
                        onPrimary: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BiometricPage(),
                          ),
                        ),
                        footer:
                            'Disarankan menyelesaikan screening terlebih dahulu.',
                      ),

                      const SizedBox(height: 40),
                      const TipsCard(),
                      const SizedBox(height: 40),

                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// =======================
/// HERO APP BAR
/// =======================
class _HeroAppBar extends StatelessWidget {
  final int score;
  const _HeroAppBar({required this.score});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB9C6FF), // soft indigo
                Color(0xFFD8DEFF), // pastel
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🧠 InsightMind',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pantau Kesehatan Mentalmu ✨',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    score == 0
                        ? 'Belum ada hasil screening'
                        : 'Skor terakhir: $score',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// =======================
/// INSIGHT CARD
/// =======================
class _InsightCard extends StatelessWidget {
  final int score;
  const _InsightCard({required this.score});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF5B6EF5), Color(0xFF8F9CFF)],
                  ),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Skor Terakhir',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      score == 0 ? '-' : '$score',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================
/// FEATURE TILE
/// =======================
class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String description;
  final String primaryLabel;
  final String? secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;
  final String? footer;

  const _FeatureTile({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPrimary,
              child: Text(primaryLabel),
            ),
          ),
          if (secondaryLabel != null && onSecondary != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onSecondary,
                child: Text(secondaryLabel!),
              ),
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 12),
            Text(
              footer!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// =======================
/// SECTION TITLE
/// =======================
class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

/// =======================
/// QUICK MOOD EMOJI
/// =======================
class _QuickMoodSection extends ConsumerWidget {
  const _QuickMoodSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMood = ref.watch(moodProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bagaimana perasaanmu hari ini?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _MoodItem(
              emoji: '😊',
              label: 'Baik',
              color: const Color(0xFFFFE8B6),
              mood: MoodType.baik,
              selected: selectedMood == MoodType.baik,
              onTap: () =>
                  ref.read(moodProvider.notifier).state = MoodType.baik,
            ),
            _MoodItem(
              emoji: '😌',
              label: 'Tenang',
              color: const Color(0xFFDFF5EA),
              mood: MoodType.tenang,
              selected: selectedMood == MoodType.tenang,
              onTap: () =>
                  ref.read(moodProvider.notifier).state = MoodType.tenang,
            ),
            _MoodItem(
              emoji: '😟',
              label: 'Cemas',
              color: const Color(0xFFFFE1E1),
              mood: MoodType.cemas,
              selected: selectedMood == MoodType.cemas,
              onTap: () =>
                  ref.read(moodProvider.notifier).state = MoodType.cemas,
            ),
            _MoodItem(
              emoji: '😴',
              label: 'Lelah',
              color: const Color(0xFFE8E4FF),
              mood: MoodType.lelah,
              selected: selectedMood == MoodType.lelah,
              onTap: () =>
                  ref.read(moodProvider.notifier).state = MoodType.lelah,
            ),
          ],
        ),
      ],
    );
  }
}


/// =======================
/// MOOD ITEM
/// =======================
class _MoodItem extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final MoodType mood;
  final bool selected;
  final VoidCallback onTap;

  const _MoodItem({
    required this.emoji,
    required this.label,
    required this.color,
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 26),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


