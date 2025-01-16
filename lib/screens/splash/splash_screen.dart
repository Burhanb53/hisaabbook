import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../setup_balance/setup_balance_screen.dart'; // Import the Setup Balance Screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();

    // Redirect to Setup Balance Screen after 3 seconds with a smooth ease-in-out fade transition
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SetupBalanceScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curveAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            return FadeTransition(
              opacity: curveAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Toggle theme and save preference
  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isDarkMode
                ? [
                    const Color(0xFF121212),
                    const Color(0xFF1E1E1E)
                  ] // Dark gradient
                : [Colors.white, const Color(0xFFF5F5F5)], // Light gradient
          ),
        ),
        child: Stack(
          children: [
            // Top-right Theme Toggle
            Positioned(
              top: 40.0,
              right: 20.0,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: _isDarkMode ? Colors.grey : Colors.black,
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (value) => _toggleTheme(),
                    activeColor: Colors.grey[400],
                    inactiveThumbColor: Colors.grey[600],
                  ),
                  Icon(
                    Icons.dark_mode,
                    color: _isDarkMode ? Colors.white : Colors.grey,
                  ),
                ],
              ),
            ),

            // Centered Full-Width Logo
            Center(
              child: Image.asset(
                _isDarkMode
                    ? 'assets/logos/logoDark.png' // Logo for dark mode
                    : 'assets/logos/logoLight.png', // Logo for light mode
                width: 200.0,
                height: 200.0,
                fit: BoxFit.contain,
              ),
            ),

            // Developer Credit at the Bottom
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Text(
                'Developed by Burhanuddin Bohra',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
