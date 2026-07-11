import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/lang_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/auth_provider.dart';

class EcoTrackApp extends ConsumerWidget {
  const EcoTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<User?>>(authProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          ref.read(profileProvider.notifier).loadProfile(user.id);
        } else {
          ref.read(profileProvider.notifier).clearProfile();
        }
      });
    });

    final themeMode = ref.watch(themeProvider);
    final localeCode = ref.watch(langProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'EcoTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: Locale(localeCode),
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
    );
  }
}
