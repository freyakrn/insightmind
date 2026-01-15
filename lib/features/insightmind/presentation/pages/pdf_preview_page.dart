import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPreviewPage extends StatelessWidget {
  final String insight;
  final int tinggi;
  final int sedang;
  final int rendah;

  /// data user
  final String nama;
  final int umur;
  final String tanggalLahir;

  const PdfPreviewPage({
    super.key,
    required this.insight,
    required this.tinggi,
    required this.sedang,
    required this.rendah,
    required this.nama,
    required this.umur,
    required this.tanggalLahir,
  });

  Future<Uint8List> _buildPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// ===============================
              /// HEADER
              /// ===============================
              pw.Text(
                'InsightMind',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Laporan Kesehatan Mental',
                style: pw.TextStyle(
                  fontSize: 14,
                ),
              ),

              pw.Divider(height: 32),

              /// ===============================
              /// DATA USER
              /// ===============================
              pw.Text(
                'Data Pengguna',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Nama           : $nama'),
              pw.Text('Umur           : $umur tahun'),
              pw.Text('Tanggal Lahir  : $tanggalLahir'),

              pw.SizedBox(height: 24),

              /// ===============================
              /// RINGKASAN RISIKO
              /// ===============================
              pw.Text(
                'Ringkasan Risiko',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Tinggi  : $tinggi'),
              pw.Text('Sedang  : $sedang'),
              pw.Text('Rendah  : $rendah'),

              pw.SizedBox(height: 24),

              /// ===============================
              /// KESIMPULAN
              /// ===============================
              pw.Text(
                'Kesimpulan',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                insight,
                textAlign: pw.TextAlign.justify,
              ),

              pw.SizedBox(height: 32),

              /// ===============================
              /// CATATAN
              /// ===============================
              pw.Text(
                'Catatan:',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Laporan ini dihasilkan berdasarkan hasil screening mandiri '
                'dan tidak menggantikan diagnosis profesional. '
                'Apabila diperlukan, disarankan untuk berkonsultasi '
                'dengan tenaga kesehatan mental.',
                textAlign: pw.TextAlign.justify,
              ),

              pw.Spacer(),

              /// ===============================
              /// FOOTER
              /// ===============================
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Dokumen ini dihasilkan secara otomatis oleh aplikasi InsightMind',
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview PDF'),
      ),
      body: PdfPreview(
        build: (format) => _buildPdf(),
        allowPrinting: true,
        allowSharing: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
      ),
    );
  }
}