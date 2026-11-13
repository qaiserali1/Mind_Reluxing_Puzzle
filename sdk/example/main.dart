import 'package:flutter/material.dart';
import 'package:rake_sdk/rake_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RakeSDK.initialize(apiKey: 'sample_api_key_123');
  runApp(const EmbedExampleApp());
}

class EmbedExampleApp extends StatelessWidget {
  const EmbedExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Mindfulness App — Rake Embed')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 320,
              height: 400,
              child: RakeSDK.embedCanvas(
                onStrokeCountChanged: (count) {
                  debugPrint('User drew $count strokes in embedded garden.');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

