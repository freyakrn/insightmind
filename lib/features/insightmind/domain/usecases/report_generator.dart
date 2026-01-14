import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class ReportGenerator {
  /// Generate PDF report hasil screening mental
  Future<File> generateMentalReport({
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
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.SizedBox(height: 20),
              _buildUserInfo(userName, age, date),
              pw.SizedBox(height: 20),
              _buildScoreSection(stressScore, moodScore),
              pw.SizedBox(height: 20),
              _buildConclusion(conclusion),
              pw.Spacer(),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/InsightMind_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// ===============================
  /// UI PDF COMPONENTS
  /// ===============================

  pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'INSIGHTMIND',
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          'Mental Health Screening Report',
          style: pw.TextStyle(
            fontSize: 14,
            color: PdfColors.grey700,
          ),
        ),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildUserInfo(String name, int age, String date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('User Information',
            style: pw.TextStyle(
                fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        _infoRow('Name', name),
        _infoRow('Age', '$age years'),
        _infoRow('Date', date),
      ],
    );
  }

  pw.Widget _buildScoreSection(double stress, double mood) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Screening Result',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        _scoreRow('Stress Level', stress),
        _scoreRow('Mood Score', mood),
      ],
    );
  }

  pw.Widget _buildConclusion(String conclusion) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Conclusion',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          conclusion,
          style: const pw.TextStyle(fontSize: 12),
          textAlign: pw.TextAlign.justify,
        ),
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Text(
          'This report is generated automatically by InsightMind Application.',
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(label,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text(': $value'),
        ],
      ),
    );
  }

  pw.Widget _scoreRow(String label, double value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(label)),
          pw.Text(
            value.toStringAsFixed(1),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
