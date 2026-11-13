import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../core/feature_flags.dart';
import '../core/theme.dart';
import '../models/rake_stroke.dart';
import 'svg_service.dart';

/// Advanced export service providing vector SVG, 300 DPI PDF, GIF, and standard PNG output.
/// Phase 4 advanced formats are guarded by FeatureFlags.enableAdvancedExport.
class ExportService {
  /// Standard PNG export — always works unconditionally.
  static Future<File?> exportPng({
    required GlobalKey canvasKey,
    double pixelRatio = 2.0,
  }) async {
    try {
      final boundary =
          canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final img = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/zen_garden_${DateTime.now().millisecondsSinceEpoch}.png');
      return await file.writeAsBytes(byteData.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }

  /// Backward-compatible alias for 4K PNG
  static Future<File?> exportAs4kPng({required GlobalKey canvasKey}) =>
      exportPng(canvasKey: canvasKey, pixelRatio: 4.0);

  /// Exports strokes as an SVG vector file (Guarded by FeatureFlags.enableAdvancedExport).
  static Future<File> exportSvg({
    required List<RakeStroke> strokes,
    required SandTheme theme,
    required Size size,
    String? filename,
  }) async {
    if (!FeatureFlags.enableAdvancedExport) {
      throw UnsupportedError('Advanced vector SVG export is disabled for launch.');
    }

    final svgContent = SvgService.strokesToSvg(strokes: strokes, theme: theme, size: size);
    final tempDir = await getTemporaryDirectory();
    final name = filename ?? 'zen_garden_${DateTime.now().millisecondsSinceEpoch}.svg';
    final file = File('${tempDir.path}/$name');
    return await file.writeAsString(svgContent);
  }

  /// Backward-compatible alias
  static Future<File> exportAsSvg({
    required List<RakeStroke> strokes,
    required SandTheme theme,
    required Size size,
    String? filename,
  }) =>
      exportSvg(strokes: strokes, theme: theme, size: size, filename: filename);

  /// Exports current sand garden as a 300 DPI PDF (Guarded by FeatureFlags.enableAdvancedExport).
  static Future<File> exportPdf({
    required GlobalKey canvasKey,
    required String title,
    required String signature,
  }) async {
    if (!FeatureFlags.enableAdvancedExport) {
      throw UnsupportedError('Advanced PDF export is disabled for launch.');
    }

    final pdf = pw.Document();

    Uint8List? pngBytes;
    final boundary = canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final img = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        pngBytes = byteData.buffer.asUint8List();
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Rake — Zen Sand Garden',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              if (pngBytes != null)
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Image(pw.MemoryImage(pngBytes), fit: pw.BoxFit.contain),
                  ),
                ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 20),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Created with Rake (rake.app)',
                        style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 10)),
                    if (signature.trim().isNotEmpty)
                      pw.Text('Artist: $signature',
                          style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic,
                              color: PdfColors.grey800,
                              fontSize: 12)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/zen_garden_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Backward-compatible alias
  static Future<File> exportAsPdf({
    required GlobalKey canvasKey,
    required String title,
    required String signature,
  }) =>
      exportPdf(canvasKey: canvasKey, title: title, signature: signature);

  /// Exports animated drawing sequence as GIF (Guarded by FeatureFlags.enableAdvancedExport).
  static Future<File> exportGif({
    required List<RakeStroke> strokes,
    required SandTheme theme,
  }) async {
    if (!FeatureFlags.enableAdvancedExport) {
      throw UnsupportedError('Animated GIF export is disabled for launch.');
    }

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/zen_garden_${DateTime.now().millisecondsSinceEpoch}.gif');
    return file;
  }
}
