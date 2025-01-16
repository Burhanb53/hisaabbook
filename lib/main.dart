import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_service.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const HisaabBookApp(),
    ),
  );
}

class HisaabBookApp extends StatelessWidget {
  const HisaabBookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Hisaab Book',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Light theme
      darkTheme: AppTheme.darkTheme, // Dark theme
      themeMode: themeService.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light, // Apply user preference
      home: const SplashScreen(),
    );
  }
}
