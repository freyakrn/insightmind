// WEEK 6: CAMERA BASED PPG-LIKE PROVIDER (FINAL)
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// =======================
/// STATE
/// =======================
class PpgState {
  final bool capturing;
  final List<double> samples;
  final double mean;
  final double variance;

  const PpgState({
    required this.capturing,
    required this.samples,
    required this.mean,
    required this.variance,
  });

  factory PpgState.initial() => const PpgState(
        capturing: false,
        samples: [],
        mean: 0,
        variance: 0,
      );

  PpgState copyWith({
    bool? capturing,
    List<double>? samples,
    double? mean,
    double? variance,
  }) {
    return PpgState(
      capturing: capturing ?? this.capturing,
      samples: samples ?? this.samples,
      mean: mean ?? this.mean,
      variance: variance ?? this.variance,
    );
  }
}

/// =======================
/// PROVIDER
/// =======================
final ppgProvider =
    StateNotifierProvider<PpgNotifier, PpgState>((ref) {
  return PpgNotifier();
});

/// =======================
/// NOTIFIER
/// =======================
class PpgNotifier extends StateNotifier<PpgState> {
  PpgNotifier() : super(PpgState.initial());

  CameraController? _controller;

  /// START CAPTURE
  Future<void> startCapture() async {
    // ⛔ Web tidak support image stream
    if (kIsWeb) return;

    // ⛔ Cegah double start
    if (state.capturing) return;

    final cameras = await availableCameras();
    final cam = cameras.first;

    _controller = CameraController(
      cam,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _controller!.initialize();

    state = state.copyWith(capturing: true);

    await _controller!.startImageStream((image) {
      // ⛔ Safety stop
      if (!state.capturing) return;

      final plane = image.planes.first;
      final buffer = plane.bytes;

      double sum = 0;
      int count = 0;

      // sampling ringan
      for (int i = 0; i < buffer.length; i += 50) {
        sum += buffer[i];
        count++;
      }

      final meanY = sum / count;

      // sliding window max 300
      final samples = [...state.samples, meanY];
      if (samples.length > 300) {
        samples.removeAt(0);
      }

      final mean =
          samples.reduce((a, b) => a + b) / samples.length;
      final variance = samples.fold(
            0.0,
            (s, x) => s + pow(x - mean, 2),
          ) /
          max(1, samples.length - 1);

      state = state.copyWith(
        samples: samples,
        mean: mean,
        variance: variance,
      );
    });
  }

  /// STOP CAPTURE
  Future<void> stopCapture() async {
    if (!state.capturing) return;

    state = state.copyWith(capturing: false);

    if (_controller != null) {
      if (_controller!.value.isStreamingImages) {
        await _controller!.stopImageStream();
      }
      await _controller!.dispose();
      _controller = null;
    }
  }
}
