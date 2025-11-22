import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialise Firebase (optionnel - commentez si pas configuré)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialise les notifications
    final notificationService = NotificationService();
    await notificationService.initialize();
    
    // S'abonne aux topics par défaut
    await notificationService.subscribeToTopic('nouveaux_articles');
    await notificationService.subscribeToTopic('evenements');
  } catch (e) {
    // Firebase non configuré - l'app fonctionne quand même
    // Silencieux en production
  }
  
  runApp(const RevLibertaireApp());
}

class RevLibertaireApp extends StatefulWidget {
  const RevLibertaireApp({super.key});

  @override
  State<RevLibertaireApp> createState() => _RevLibertaireAppState();
}

class _RevLibertaireAppState extends State<RevLibertaireApp> {
  final ThemeService _themeService = ThemeService();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await _themeService.isDarkMode();
    setState(() => _isDarkMode = isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REVLIBERTAIRE',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
      primaryColor: const Color(0xFF8B0000),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF8B0000),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B0000),
        primary: const Color(0xFF8B0000),
        brightness: Brightness.light,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      primaryColor: const Color(0xFF8B0000),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF8B0000),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B0000),
        primary: const Color(0xFF8B0000),
        brightness: Brightness.dark,
      ),
    );
  }
}
