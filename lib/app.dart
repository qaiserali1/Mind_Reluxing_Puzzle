import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/feature_flags.dart';
import 'core/theme.dart';
import 'features/ar/ar_garden_screen.dart';
import 'features/collab/collab_garden_screen.dart';
import 'features/macos/macos_menu.dart';
import 'providers/garden_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/gallery_screen.dart';
import 'screens/garden_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'services/achievement_service.dart';
import 'widgets/responsive_layout.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// Root application widget supporting dynamic themes, multi-language routing,
/// guarded Phase 4 routes, and privacy endpoints.
class RakeApp extends StatelessWidget {
  const RakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    AchievementService.navigatorKey = appNavigatorKey;
    final isMac = !kIsWeb && Platform.isMacOS;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GardenProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<GardenProvider>(
        builder: (context, garden, _) {
          Widget app = MaterialApp(
            navigatorKey: appNavigatorKey,
            title: 'Rake',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFor(garden.theme),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const ResponsiveLayout(
              mobileChild: SplashScreen(),
            ),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/garden':
                  return MaterialPageRoute(builder: (_) => const GardenScreen());
                case '/settings':
                  return MaterialPageRoute(builder: (_) => const SettingsScreen());
                case '/gallery':
                  return MaterialPageRoute(builder: (_) => const GalleryScreen());
                case '/premium':
                  if (!FeatureFlags.enablePremium) return null;
                  return MaterialPageRoute(builder: (_) => const PremiumScreen());
                case '/onboarding':
                  if (!FeatureFlags.enableOnboarding) return null;
                  return MaterialPageRoute(builder: (_) => const OnboardingScreen());
                case '/privacy':
                  return MaterialPageRoute(builder: (_) => const PrivacyScreen());

                // ============================================================
                // Phase 4 Guarded Routes (Return null if disabled)
                // ============================================================
                case '/ar':
                  if (!FeatureFlags.enableARMode) return null;
                  return MaterialPageRoute(builder: (_) => const ArGardenScreen());

                case '/collab':
                  if (!FeatureFlags.enableCollaboration) return null;
                  final args = settings.arguments as Map<String, dynamic>?;
                  final sessionId = args?['sessionId'] as String? ?? '';
                  return MaterialPageRoute(
                    builder: (_) => CollabGardenScreen(sessionId: sessionId),
                  );

                case '/watch':
                  if (!FeatureFlags.enableAppleWatch) return null;
                  return null;

                case '/macos':
                  if (!FeatureFlags.enableMacOS) return null;
                  return null;

                default:
                  return null;
              }
            },
          );

          // Wrap macOS menu bar only if Phase 4 macOS flag is explicitly active
          if (isMac && FeatureFlags.enableMacOS) {
            return PlatformMenuBar(
              menus: MacOsMenuBar.buildMenus(
                onNewGarden: () => garden.finishErase(),
                onSaveGarden: () {},
                onShareGarden: () {},
                onEraseGarden: () => garden.finishErase(),
                onOpenSettings: () {},
              ),
              child: app,
            );
          }

          return app;
        },
      ),
    );
  }
}
