import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'view_purchase_screen.dart';

class PurchaseScreen extends StatefulWidget {
  final String dealerName;

  const PurchaseScreen({Key? key, required this.dealerName}) : super(key: key);

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final List<Map<String, dynamic>> purchases = [
    {
      "purchase_id": "P001",
      "view_bill": "View Bill 1",
      "amount": 5000,
      "is_paid": true,
      "date": "2024-11-15",
    },
    {
      "purchase_id": "P002",
      "view_bill": "View Bill 2",
      "amount": 7000,
      "is_paid": false,
      "date": "2024-10-20",
    },
    {
      "purchase_id": "P003",
      "view_bill": "View Bill 3",
      "amount": 3000,
      "is_paid": true,
      "date": "2024-10-10",
    },
    {
      "purchase_id": "P004",
      "view_bill": "View Bill 4",
      "amount": 8000,
      "is_paid": false,
      "date": "2024-09-25",
    },
    {
      "purchase_id": "P005",
      "view_bill": "View Bill 5",
      "amount": 10000,
      "is_paid": true,
      "date": "2024-09-05",
    },
  ];

  List<Map<String, dynamic>> filteredPurchases = [];
  String searchQuery = "";
  String selectedStatus = "Paid";
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    filteredPurchases = List.from(purchases);

    // Sort purchases by date in descending order
    purchases.sort((a, b) {
      final dateA = DateTime.parse(a["date"]);
      final dateB = DateTime.parse(b["date"]);
      return dateB.compareTo(dateA);
    });
  }

  void applyFilters() {
    setState(() {
      filteredPurchases = purchases.where((purchase) {
        final purchaseIdMatch = purchase["purchase_id"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final billMatch = purchase["view_bill"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final amountMatch = purchase["amount"].toString().contains(searchQuery);
        return purchaseIdMatch || billMatch || amountMatch;
      }).toList();
    });
  }

  // Method to show the dialog
  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Bill Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Amount Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Dropdown for Paid/Unpaid
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ["Paid", "Unpaid"].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value ?? "Paid";
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Date Picker
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ),
                controller: TextEditingController(
                  text: "${selectedDate.toLocal()}".split(' ')[0],
                ),
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
                // Handle submission logic
                print("Status: $selectedStatus, Date: $selectedDate");
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Widget buildPurchaseCard(
      Map<String, dynamic> purchase, ThemeData theme, BuildContext context) {
    final isPaid = purchase["is_paid"];

    return InkWell(
      onTap: () {
        // Handle tap event
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseBillScreen(),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Padding(
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
                      "Purchase ID: ${purchase["purchase_id"]}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // Navigate to bill view
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Bill Details"),
                              content: const Text(
                                  "Details of the bill will appear here."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "View Bill",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
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
                      "₹${purchase["amount"]}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPaid ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat("dd/MM/yyyy")
                          .format(DateTime.parse(purchase["date"])),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dealerName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showPaymentDialog,
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
                hintText: "Search by Purchase ID, Bill, or Amount...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Purchases List
          Expanded(
            child: ListView.builder(
              itemCount: filteredPurchases.length,
              itemBuilder: (context, index) {
                final purchase = filteredPurchases[index];
                return buildPurchaseCard(purchase, theme, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
