# Rake Flutter Developer SDK (`rake_sdk`)

The `rake_sdk` package empowers third-party meditation, wellness, education, and art applications to easily embed a tactile, meditative sand garden directly into their Flutter applications.

## Installation
Add `rake_sdk` to your `pubspec.yaml`:
```yaml
dependencies:
  rake_sdk:
    path: ../sdk
```

## Quick Start
```dart
import 'package:flutter/material.dart';
import 'package:rake_sdk/rake_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RakeSDK.initialize(apiKey: 'YOUR_API_KEY');
  runApp(const MyApp());
}

class ZenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          height: 400,
          child: RakeSDK.embedCanvas(
            readOnly: false,
            onStrokeCountChanged: (count) {
              print('Strokes: $count');
            },
          ),
        ),
      ),
    );
  }
}
```

