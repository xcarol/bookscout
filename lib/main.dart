import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'
    show PlatformDispatcher, TargetPlatform, defaultTargetPlatform, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:bookscout/firebase_options.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/screens/main_screen.dart';
import 'package:bookscout/services/core/database_service.dart';
import 'package:bookscout/services/core/error_service.dart';
import 'package:bookscout/services/settings/language_service.dart';
import 'package:bookscout/services/settings/preferences_service.dart';
import 'package:bookscout/services/settings/theme_service.dart';
import 'package:bookscout/services/system/app_lifecycle_service.dart';
import 'package:bookscout/services/books/library_service.dart';
import 'package:bookscout/utils/app_constants.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main(List<String> args) async {
  _runMain();
}

void _runMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Future.wait([
      dotenv.load(fileName: ".env"),
      PreferencesService().init(),
      DatabaseService.init(),
    ]);
  } catch (error, stackTrace) {
    ErrorService.log(
      error,
      userMessage: 'Error initializing services',
      stackTrace: stackTrace,
    );
  }

  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (Firebase.apps.isEmpty) {
        try {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        } catch (e) {
          if (e.toString().contains('duplicate-app')) {
            await Firebase.initializeApp();
          } else {
            rethrow;
          }
        }
      }

      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kDebugMode,
      );
    }
  } catch (error, stackTrace) {
    ErrorService.log(
      error,
      userMessage: 'Error initializing Firebase',
      stackTrace: stackTrace,
      reportToCrashlytics: false,
    );
  }

  debugPrint('Running BookScout...');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => LibraryService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppLifecycleService.instance.init();

    final themeProvider = ThemeService();
    themeProvider.setupTheme();
  }

  @override
  void dispose() {
    AppLifecycleService.instance.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageService>(context);
    final themeProvider = ThemeService();

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConstants.supportedLanguages
          .map((e) => LanguageService.parseLocale(e))
          .toList(),
      locale: languageProvider.locale,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: themeProvider.lightColorScheme,
        scrollbarTheme: themeProvider.lightScrollbarTheme,
        extensions: <ThemeExtension<dynamic>>[
          themeProvider.lightCustomColors,
          themeProvider.lightTitleListTheme,
        ],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: themeProvider.darkColorScheme,
        scrollbarTheme: themeProvider.darkScrollbarTheme,
        extensions: <ThemeExtension<dynamic>>[
          themeProvider.darkCustomColors,
          themeProvider.darkTitleListTheme,
        ],
      ),
      title: 'BookScout',
      home: const MainScreen(),
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorObservers: [routeObserver],
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          const statusBarBrightness = Brightness.light;
          const navBarBrightness = Brightness.light;

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
              systemNavigationBarIconBrightness: navBarBrightness,
              statusBarColor: Colors.transparent,
              systemStatusBarContrastEnforced: false,
              statusBarIconBrightness: statusBarBrightness,
            ),
          );
        });

        return child!;
      },
    );
  }
}
