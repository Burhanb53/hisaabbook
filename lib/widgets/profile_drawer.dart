import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_service.dart';
import '../screens/setup_balance/balance_screen.dart';
import '../screens/transactions/transactions_screen.dart';
import '../screens/bills/sales_screen.dart';
import '../screens/purchase/dealer_screen.dart';
import '../screens/expenses/expense_screen.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context);
    final isDarkMode = themeService.isDarkMode;

    return Drawer(
      child: Column(
        children: [
          // Custom Drawer Header with adjusted background
          GestureDetector(
            onTap: () {
              // Add desired functionality if needed
            },
            child: Container(
              color: theme.scaffoldBackgroundColor, // Same color as drawer body
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile-pic.png', // Profile picture
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    // Ensures text wraps properly
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hii, Burhanuddin',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rajasthan Steel And Crockery', // Wrapping text
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 12, // Reduced size for better fit
                          ),
                          maxLines: 2, // Ensures text wraps within two lines
                          overflow: TextOverflow
                              .ellipsis, // Handles overflow gracefully
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Theme Toggle Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? Colors.white : Colors.grey[800],
              ),
              activeColor: theme.primaryColor,
              value: isDarkMode,
              onChanged: (_) => themeService.toggleTheme(),
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.account_balance, 'Account Balance', () {
                  // Add Account Balance action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BalanceScreen()),
                  );
                }),
                _buildDrawerItem(Icons.swap_horiz, 'Transactions', () {
                  // Add Transactions action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransactionScreen()),
                  );
                }),
                _buildDrawerItem(Icons.attach_money, 'Sales', () {
                  // Add Sales action
                  // Replace the below code with your SalesScreen navigation or logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SalesScreen()),
                  );
                }),
                _buildDrawerItem(Icons.shopping_cart, 'Purchase', () {
                  // Add Purchase action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DealerScreen()),
                  );
                }),
                _buildDrawerItem(Icons.money, 'Expense', () {
                  // Add Expense action
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpenseScreen()),
                  );
                }),
                _buildDrawerItem(Icons.bar_chart, 'Purchase Graph', () {
                  // Add Purchase Graph action
                }),
                _buildDrawerItem(Icons.show_chart, 'Sales Graph', () {
                  // Add Sales Graph action
                }),
              ],
            ),
          ),

          // Logout button at the bottom
          Column(
            children: [
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Add logout functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build drawer items
  Widget _buildDrawerItem(
      IconData icon, String title, GestureTapCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
