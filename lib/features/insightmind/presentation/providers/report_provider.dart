import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;


/// ===============================
/// STATE
/// ===============================
class ReportState {
  final bool isLoading;
  final File? reportFile;
  final String? errorMessage;

  const ReportState({
    this.isLoading = false,
    this.reportFile,
    this.errorMessage,
  });

  ReportState copyWith({
    bool? isLoading,
    File? reportFile,
    String? errorMessage,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      reportFile: reportFile ?? this.reportFile,
      errorMessage: errorMessage,
    );
  }
}

/// ===============================
/// NOTIFIER
/// ===============================
class ReportNotifier extends StateNotifier<ReportState> {
  ReportNotifier() : super(const ReportState());

  /// Generate laporan PDF InsightMind
  Future<void> generateReport({
    required String userName,
    required int age,
    required String date,
    required double stressScore,
    required double moodScore,
    required String conclusion,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final file = await _generateAndSavePdf(
        userName: userName,
        age: age,
        date: date,
        stressScore: stressScore,
        moodScore: moodScore,
        conclusion: conclusion,
      );

      state = state.copyWith(
        isLoading: false,
        reportFile: file,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal membuat laporan PDF',
      );
    }
  }

  /// ===============================
  /// GENERATE & SAVE PDF
  /// ===============================
  Future<File> _generateAndSavePdf({
    required String userName,
    required int age,
    required String date,
    required double stressScore,
    required double moodScore,
    required String conclusion,
  }) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('InsightMind - Laporan Kesehatan Mental',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Nama: $userName'),
              pw.Text('Umur: $age tahun'),
              pw.Text('Tanggal: $date'),
              pw.Divider(),
              pw.Text('Skor Stress: $stressScore'),
              pw.Text('Skor Mood: $moodScore'),
              pw.SizedBox(height: 12),
              pw.Text('Kesimpulan:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(conclusion),
            ],
          ),
        ),
      ),
    );

    final bytes = await pdf.save();

    return await _saveToDownload(bytes);
  }

  /// ===============================
  /// SAVE TO DOWNLOAD FOLDER
  /// ===============================
  Future<File> _saveToDownload(Uint8List bytes) async {
    final directory = Directory('/storage/emulated/0/Download');

    final fileName =
        'InsightMind_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }
}

/// ===============================
/// PROVIDER
/// ===============================
final reportProvider =
    StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  return ReportNotifier();
});
