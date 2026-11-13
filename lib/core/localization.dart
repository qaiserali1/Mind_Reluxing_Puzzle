import 'package:flutter/material.dart';

/// Localization configuration supporting 10 European languages.
class AppLocalization {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('de'),
    Locale('fr'),
    Locale('es'),
    Locale('it'),
    Locale('pt'),
    Locale('nl'),
    Locale('pl'),
    Locale('sv'),
    Locale('tr'),
  ];

  static const Locale fallbackLocale = Locale('en');
  static const String path = 'assets/l10n';

  static const Map<String, String> languageNames = {
    'en': 'English',
    'de': 'Deutsch',
    'fr': 'Français',
    'es': 'Español',
    'it': 'Italiano',
    'pt': 'Português',
    'nl': 'Nederlands',
    'pl': 'Polski',
    'sv': 'Svenska',
    'tr': 'Türkçe',
  };

  static const Map<String, String> languageFlags = {
    'en': '🇬🇧',
    'de': '🇩🇪',
    'fr': '🇫🇷',
    'es': '🇪🇸',
    'it': '🇮🇹',
    'pt': '🇵🇹',
    'nl': '🇳🇱',
    'pl': '🇵🇱',
    'sv': '🇸🇪',
    'tr': '🇹🇷',
  };
}
