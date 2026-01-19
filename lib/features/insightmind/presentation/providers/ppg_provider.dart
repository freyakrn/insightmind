// WEEK 6: CAMERA BASED PPG-LIKE PROVIDER (FINAL + RESET)
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
  int _sessionId = 0;

  /// =======================
  /// START CAPTURE
  /// =======================
  Future<void> startCapture() async {
  if (kIsWeb || state.capturing) return;

  final int currentSession = ++_sessionId;

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
    // ❗ BLOK CALLBACK LAMA
    if (!state.capturing || currentSession != _sessionId) return;

    final plane = image.planes.first;
    final buffer = plane.bytes;

    double sum = 0;
    int count = 0;

    for (int i = 0; i < buffer.length; i += 50) {
      sum += buffer[i];
      count++;
    }

    final meanY = sum / count;

    final samples = [...state.samples, meanY];
    if (samples.length > 300) samples.removeAt(0);

    final mean =
        samples.reduce((a, b) => a + b) / samples.length;

    final variance = samples.fold<double>(
          0.0,
          (s, x) => s + pow(x - mean, 2),
        ) /
        (samples.length - 1).clamp(1, double.infinity);

    state = state.copyWith(
      samples: samples,
      mean: mean,
      variance: variance,
    );
  });
}

  /// =======================
  /// STOP CAPTURE
  /// =======================
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

  /// =======================
  /// RESET TOTAL (INI KUNCI)
  /// =======================
  Future<void> reset() async {
    // hentikan stream & kamera
    if (state.capturing) {
      await stopCapture();
    }

    // reset state ke awal
    state = PpgState.initial();
  }
}
