import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/profile_drawer.dart';
import 'add_sale_screen.dart';
import '../bills/bill_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onProfileTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: const ProfileDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: theme.brightness == Brightness.dark
                ? [Colors.black, Colors.grey[900]!]
                : [Colors.white, Colors.grey[200]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Sale and Total Customer Cards
              Row(
                children: [
                  _buildStatCard(
                    title: 'Sale',
                    value: '₹50,000',
                    icon: Icons.attach_money,
                    theme: Theme.of(context),
                    color: Colors.green, // Dynamic color
                  ),
                  _buildStatCard(
                    title: 'Customers',
                    value: '120',
                    icon: Icons.people,
                    theme: Theme.of(context),
                    color:
                        const Color.fromARGB(255, 62, 74, 189), // Dynamic color
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Today's Sale and Create Bill Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Sale",
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add bill functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddSaleScreen()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Sale"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: theme.brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // List of Bill Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildBillCard(
                    billId: "BILL1234$index",
                    products: "Product A, Product B",
                    payment: "\$${(index + 1) * 100}",
                    date: "2024-11-16",
                    theme: theme,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card for Total Sale and Total Customer
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required ThemeData theme,
    required Color color, // Correctly define and use the color parameter
  }) {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 100), // Constrain height
        child: Card(
          elevation: 4,
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              children: [
                Icon(icon, size: 40, color: theme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        maxLines: 1, // Prevent overflow
                        overflow:
                            TextOverflow.ellipsis, // Ellipsize if necessary
                      ),
                      const SizedBox(height: 5),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color, // Use the provided color parameter
                          ),
                          maxLines: 1, // Prevent overflow
                          overflow:
                              TextOverflow.ellipsis, // Ellipsize if necessary
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Bill Card Design
  Widget _buildBillCard({
    required String billId,
    required String products,
    required String payment,
    required String date,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillScreen(
              billId: "123456",
              products: "Product 1, Product 2, Product 1, Product 2",
              name: "John Doe",
              contact: "9876543210",
              totalAmount: 5000,
              paidAmount: 3000,
              date: '12-11-2024',
              transactions: [
                {
                  "id": "T001789255892",
                  "amount": 2000,
                  "mode": "Cash",
                  "date": "23/11/2024"
                },
                {
                  "id": "T002874985489",
                  "amount": 1500,
                  "mode": "Online",
                  "date": "23/11/2024"
                },
              ],
            ),
          ),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 80), // Constrain height
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 12.0),
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Section
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bill ID: $billId",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        maxLines: 1, // Prevent overflow
                        overflow:
                            TextOverflow.ellipsis, // Ellipsize if necessary
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Products: $products",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                        maxLines: 1, // Wrap or truncate text to 2 lines
                        overflow:
                            TextOverflow.ellipsis, // Ellipsize if necessary
                      ),
                    ],
                  ),
                ),

                // Right Section
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$payment",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // Green color for payment
                        ),
                        maxLines: 1, // Prevent overflow
                        overflow:
                            TextOverflow.ellipsis, // Ellipsize if necessary
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "$date",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                        maxLines: 1, // Prevent overflow
                        overflow:
                            TextOverflow.ellipsis, // Ellipsize if necessary
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
