# Rake Home Screen Widget Integration

Rake features native Home Screen widgets for iOS (WidgetKit / SwiftUI) and Android (AppWidgetProvider / RemoteViews) through the `home_widget` plugin.

## iOS Setup (Xcode)
1. Open the iOS project in Xcode: `open ios/Runner.xcworkspace`.
2. Select **File > New > Target... > Widget Extension**.
3. Name it `RakeWidget`, disable "Include Live Activity", and select "Next".
4. Add the App Group capability to both `Runner` and `RakeWidgetExtension` targets:
   - App Group identifier: `group.app.rake.widget`
5. Replace `ios/RakeWidget/RakeWidget.swift` with the provided implementation.

## Android Setup
1. In `android/app/src/main/AndroidManifest.xml`, declare the receiver inside `<application>`:
```xml
<receiver android:name="app.rake.game.RakeWidget"
    android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/rake_widget_info" />
</receiver>
```
2. The widget layout and provider are located in:
   - `android/app/src/main/kotlin/app/rake/game/RakeWidget.kt`
   - `android/app/src/main/res/xml/rake_widget_info.xml`
   - `android/app/src/main/res/layout/rake_widget.xml`

