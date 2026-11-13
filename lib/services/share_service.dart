import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants.dart';
import '../core/theme.dart';

/// Service for rendering the canvas with an elegant watermark and sharing via system share sheet.
class ShareService {
  /// Captures the sand canvas, composes signature & watermark, and opens the system share dialog.
  static Future<bool> shareCanvas({
    required GlobalKey canvasKey,
    required String signature,
    required bool isPremium,
  }) async {
    try {
      final boundary = canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return false;

      // High-res pixel ratio (4.0 for premium 4K exports, 2.0 for standard)
      final pixelRatio = isPremium ? 4.0 : 2.0;
      final ui.Image rawImage = await boundary.toImage(pixelRatio: pixelRatio);

      // Compose final image with watermark
      final composedBytes = await _composeWatermarkedImage(rawImage, signature, isPremium);
      if (composedBytes == null) return false;

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/zen_garden_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(tempFilePath);
      await file.writeAsBytes(composedBytes);

      await Share.shareXFiles(
        [XFile(tempFilePath)],
        text: AppConstants.shareDefaultText,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Composes the original canvas image with a subtle logo and optional user signature.
  static Future<List<int>?> _composeWatermarkedImage(
    ui.Image originalImage,
    String signature,
    bool isPremium,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final width = originalImage.width.toDouble();
    final height = originalImage.height.toDouble();

    // 1. Draw base garden image
    canvas.drawImage(originalImage, Offset.zero, Paint());

    // 2. Draw "Rake" brand watermark (bottom-left)
    final logoSpan = TextSpan(
      children: [
        TextSpan(
          text: AppConstants.appName,
          style: GoogleFonts.cormorantGaramond(
            color: AppColors.textPrimary.withOpacity(0.35),
            fontSize: width * 0.038,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        if (!isPremium)
          TextSpan(
            text: '\nrake.app',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary.withOpacity(0.30),
              fontSize: width * 0.022,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );

    final logoPainter = TextPainter(
      text: logoSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    logoPainter.paint(
      canvas,
      Offset(width * 0.05, height - logoPainter.height - height * 0.04),
    );

    // 3. Draw signature (bottom-right) if provided
    if (signature.trim().isNotEmpty) {
      final sigSpan = TextSpan(
        text: signature.trim(),
        style: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary.withOpacity(0.50),
          fontSize: width * 0.035,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      );

      final sigPainter = TextPainter(
        text: sigSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      sigPainter.paint(
        canvas,
        Offset(
          width - sigPainter.width - width * 0.05,
          height - sigPainter.height - height * 0.04,
        ),
      );
    }

    final picture = recorder.endRecording();
    final finalImage = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}

