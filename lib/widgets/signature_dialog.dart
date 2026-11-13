import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../services/haptic_service.dart';

/// Modal dialog allowing the user to configure an elegant artist signature.
class SignatureDialog extends StatefulWidget {
  final String initialSignature;
  final ValueChanged<String> onSaved;

  const SignatureDialog({
    super.key,
    required this.initialSignature,
    required this.onSaved,
  });

  static Future<void> show(
    BuildContext context, {
    required String initialSignature,
    required ValueChanged<String> onSaved,
  }) {
    return showDialog(
      context: context,
      barrierColor: AppColors.textPrimary.withOpacity(0.3),
      builder: (_) => SignatureDialog(
        initialSignature: initialSignature,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<SignatureDialog> createState() => _SignatureDialogState();
}

class _SignatureDialogState extends State<SignatureDialog> {
  late TextEditingController _controller;
  String _previewText = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSignature);
    _previewText = widget.initialSignature;
    _controller.addListener(() {
      setState(() {
        _previewText = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
        side: const BorderSide(color: AppColors.borderLight, width: 1.0),
      ),
      title: Text(
        tr('signature'),
        style: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              maxLength: 20,
              autofocus: true,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: tr('signature_hint'),
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
                filled: true,
                fillColor: AppColors.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Live Serif Preview
            Text(
              'Preview:',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.sandBase.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Text(
                _previewText.trim().isEmpty ? 'Your Name' : _previewText.trim(),
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  color: _previewText.trim().isEmpty
                      ? AppColors.textSecondary.withOpacity(0.4)
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        TextButton(
          onPressed: () {
            HapticService.lightTap();
            Navigator.pop(context);
          },
          child: Text(
            tr('cancel'),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            HapticService.lightTap();
            widget.onSaved(_controller.text.trim());
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            tr('save'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

