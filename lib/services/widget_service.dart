import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

/// Service synchronizing the latest sand pattern and daily inspiration with native Home Screen widgets.
class WidgetService {
  static const String appGroupId = 'group.app.rake.widget';
  static const String androidWidgetProvider = 'RakeWidget';

  /// Updates widget payload with latest pattern and daily state.
  static Future<void> updateHomeWidget({
    String? latestPatternId,
    String? dailyPatternName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isPremium = prefs.getBool(AppConstants.keyPremiumUnlocked) ?? false;

      await HomeWidget.saveWidgetData<String>('daily_pattern_name', dailyPatternName ?? 'Zen Waves');
      await HomeWidget.saveWidgetData<bool>('is_premium', isPremium);

      await HomeWidget.updateWidget(
        name: androidWidgetProvider,
        iOSName: 'RakeWidget',
      );
    } catch (_) {}
  }
}

