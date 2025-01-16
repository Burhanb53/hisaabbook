import 'package:flutter/material.dart';
import 'add_dealer_screen.dart';
import 'purchase_screen.dart';

class DealerScreen extends StatefulWidget {
  const DealerScreen({Key? key}) : super(key: key);

  @override
  _DealerScreenState createState() => _DealerScreenState();
}

class _DealerScreenState extends State<DealerScreen> {
  final List<Map<String, dynamic>> dealers = [
    {
      "name": "John Doe",
      "contact": "9876543210",
      "address": "123 Street, City, State, Long Address for Testing Overflow",
    },
    {
      "name": "Jane Smith",
      "contact": "8765432109",
      "address": "456 Avenue, City, State",
    },
    {
      "name": "Robert Johnson",
      "contact": "7654321098",
      "address": "789 Boulevard, City, State",
    },
    {
      "name": "Alice Brown",
      "contact": "6543210987",
      "address": "101 Parkway, City, State",
    },
  ];

  List<Map<String, dynamic>> filteredDealers = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredDealers = List.from(dealers);
  }

  void applyFilters() {
    setState(() {
      filteredDealers = dealers.where((dealer) {
        final nameMatch =
            dealer["name"].toLowerCase().contains(searchQuery.toLowerCase());
        final contactMatch = dealer["contact"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final addressMatch = dealer["address"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        return nameMatch || contactMatch || addressMatch;
      }).toList();
    });
  }

  void showEditDialog(Map<String, dynamic> dealer) {
    TextEditingController nameController =
        TextEditingController(text: dealer["name"]);
    TextEditingController contactController =
        TextEditingController(text: dealer["contact"]);
    TextEditingController addressController =
        TextEditingController(text: dealer["address"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Dealer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Dealer Name"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: "Contact"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  dealer["name"] = nameController.text;
                  dealer["contact"] = contactController.text;
                  dealer["address"] = addressController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

 Widget buildDealerCard(
      Map<String, dynamic> dealer, ThemeData theme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to PurchaseScreen on card tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseScreen(dealerName: dealer["name"]),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Left Section
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dealer["name"],
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dealer["address"],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Right Section
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          dealer["contact"],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Edit Icon
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  // Show edit dialog on edit icon tap
                  showEditDialog(dealer);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dealers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: "Add Dealer",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDealerScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                applyFilters();
              },
              decoration: InputDecoration(
                hintText: "Search by Name, Contact, or Address...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Dealer List
          Expanded(
            child: ListView.builder(
              itemCount: filteredDealers.length,
              itemBuilder: (context, index) {
                final dealer = filteredDealers[index];
                return buildDealerCard(dealer, theme, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
