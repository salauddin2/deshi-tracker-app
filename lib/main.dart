import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router/app_router.dart';
import 'providers/data_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPrefs),
    ],
  );
  
  try {
    await Firebase.initializeApp();
    // Initialize Notification Service once at startup
    await container.read(notificationServiceProvider).init();
  } catch (e) {
    debugPrint('Startup service initialization failed: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DesiTrackerApp(),
    ),
  );
}

class DesiTrackerApp extends ConsumerWidget {
  const DesiTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Desi Tracker',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A3C5E),
          primary: const Color(0xFF1A3C5E),
          surface: const Color(0xFFF9F7F1),
        ),
        textTheme: GoogleFonts.jostTextTheme(),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
