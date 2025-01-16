import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_service.dart';
import '../home/home_screen.dart';

class SetupBalanceScreen extends StatefulWidget {
  const SetupBalanceScreen({Key? key}) : super(key: key);

  @override
  State<SetupBalanceScreen> createState() => _SetupBalanceScreenState();
}

class _SetupBalanceScreenState extends State<SetupBalanceScreen> {
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _onlineController = TextEditingController();

  void _submitBalances() {
    final cashBalance = _cashController.text.trim();
    final onlineBalance = _onlineController.text.trim();

    if (cashBalance.isEmpty || onlineBalance.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill in both fields!"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Navigate to HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isDarkMode = themeService.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppTheme.darkTheme.cardColor : Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Initial Account Setup",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode, color: Colors.grey),
              Switch(
                value: isDarkMode,
                onChanged: (_) => themeService.toggleTheme(),
                activeColor: Colors.grey[300],
                inactiveThumbColor: Colors.grey[600],
              ),
              const Icon(Icons.dark_mode, color: Colors.grey),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    AppTheme.darkTheme.cardColor,
                    AppTheme.darkTheme.scaffoldBackgroundColor,
                  ]
                : [
                    AppTheme.lightTheme.cardColor,
                    AppTheme.lightTheme.scaffoldBackgroundColor,
                  ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.darkTheme.cardColor
                    : AppTheme.lightTheme.cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter Account Balances",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Cash Balance Field
                  TextField(
                    controller: _cashController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Cash Balance",
                      filled: true,
                      fillColor: isDarkMode ? Colors.black54 : Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Online Balance Field
                  TextField(
                    controller: _onlineController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Online Balance",
                      filled: true,
                      fillColor: isDarkMode ? Colors.black54 : Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitBalances,
                      child: const Text("Save Balances"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
