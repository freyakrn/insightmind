// WEEK 6: ACCELEROMETER PROVIDER
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Model fitur accelerometer
class AccelFeature {
  final double mean;
  final double variance;
  final bool isStable;

  AccelFeature({
    required this.mean,
    required this.variance,
    required this.isStable,
  });
}

/// Provider fitur accelerometer
final accelFeatureProvider =
    StateNotifierProvider<AccelFeatureNotifier, AccelFeature>((ref) {
  return AccelFeatureNotifier();
});

class AccelFeatureNotifier extends StateNotifier<AccelFeature> {
  AccelFeatureNotifier()
      : super(
          AccelFeature(
            mean: 0,
            variance: 0,
            isStable: true,
          ),
        ) {
    _start();
  }

  final List<double> _buffer = [];

  void _start() {
    accelerometerEventStream().listen((event) {
      final magnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      _buffer.add(magnitude);
      if (_buffer.length > 50) _buffer.removeAt(0);

      _updateStats();
    });
  }

  void _updateStats() {
    if (_buffer.isEmpty) return;

    final mean = _buffer.reduce((a, b) => a + b) / _buffer.length;

    final variance = _buffer.length > 1
        ? _buffer.fold<double>(
              0.0,
              (sum, x) => sum + pow(x - mean, 2).toDouble(),
            ) /
            (_buffer.length - 1)
        : 0.0;

    final isStable = variance < 0.05;

    state = AccelFeature(
      mean: mean,
      variance: variance,
      isStable: isStable,
    );
  }
}
