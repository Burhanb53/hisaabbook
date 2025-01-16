import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction_detail_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Map<String, dynamic>> transactions = [
    {
      "transaction_id": "T001",
      "transaction_name": "Sell Product A",
      "type": "In",
      "transaction_type": "Sell",
      "payment_mode": "Cash",
      "amount": 15000,
      "date": "2024-09-15 10:30 AM",
      "reference_id": "REF001",
    },
    {
      "transaction_id": "T002",
      "transaction_name": "Purchase Material B",
      "type": "Out",
      "transaction_type": "Purchase",
      "payment_mode": "Online",
      "amount": 10000,
      "date": "2024-09-14 2:45 PM",
      "reference_id": "REF002",
    },
    {
      "transaction_id": "T003",
      "transaction_name": "Office Rent",
      "type": "Out",
      "transaction_type": "Expense",
      "payment_mode": "Cash",
      "amount": 25000,
      "date": "2024-09-01 9:00 AM",
      "reference_id": "REF003",
    },
    {
      "transaction_id": "T004",
      "transaction_name": "Sell Product B",
      "type": "In",
      "transaction_type": "Sell",
      "payment_mode": "Online",
      "amount": 20000,
      "date": "2024-09-18 11:45 AM",
      "reference_id": "REF004",
    },
    {
      "transaction_id": "T005",
      "transaction_name": "Marketing Campaign",
      "type": "Out",
      "transaction_type": "Expense",
      "payment_mode": "Online",
      "amount": 12000,
      "date": "2024-09-20 3:30 PM",
      "reference_id": "REF005",
    },
    {
      "transaction_id": "T006",
      "transaction_name": "Balance Update",
      "type": "In",
      "transaction_type": "Balance Update",
      "payment_mode": "Cash",
      "amount": 5000,
      "date": "2024-09-25 8:00 AM",
      "reference_id": "REF006",
    },
    {
      "transaction_id": "T007",
      "transaction_name": "Refund to Customer",
      "type": "Out",
      "transaction_type": "Refund",
      "payment_mode": "Cash",
      "amount": 7000,
      "date": "2024-09-28 6:00 PM",
      "reference_id": "REF007",
    },
    {
      "transaction_id": "T008",
      "transaction_name": "Sell Product C",
      "type": "In",
      "transaction_type": "Sell",
      "payment_mode": "Online",
      "amount": 30000,
      "date": "2024-10-01 10:15 AM",
      "reference_id": "REF008",
    },
    {
      "transaction_id": "T009",
      "transaction_name": "Purchase Equipment",
      "type": "Out",
      "transaction_type": "Purchase",
      "payment_mode": "Online",
      "amount": 45000,
      "date": "2024-10-05 4:00 PM",
      "reference_id": "REF009",
    },
    {
      "transaction_id": "T010",
      "transaction_name": "Electricity Bill",
      "type": "Out",
      "transaction_type": "Expense",
      "payment_mode": "Cash",
      "amount": 8000,
      "date": "2024-10-10 2:00 PM",
      "reference_id": "REF010",
    },
  ];

  List<Map<String, dynamic>> filteredTransactions = [];
  String searchQuery = "";
  String selectedType = "All";
  String selectedMode = "All";
  String selectedMonth = "All";
  String selectedTransactionType = "All";
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize filteredTransactions with all transactions
    filteredTransactions = List.from(transactions);
  }

  void applyFilters() {
    setState(() {
      filteredTransactions = transactions.where((transaction) {
        final dateTime =
            DateFormat("yyyy-MM-dd h:mm a").parse(transaction["date"]);

        // Search Filter
        final matchesSearch = searchQuery.isEmpty ||
            transaction["transaction_name"]
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            transaction["transaction_id"]
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            transaction["amount"].toString().contains(searchQuery);

        // Type Filter
        final matchesType =
            selectedType == "All" || transaction["type"] == selectedType;

        // Mode Filter
        final matchesMode = selectedMode == "All" ||
            transaction["payment_mode"] == selectedMode;

        // Transaction Type Filter
        final matchesTransactionType = selectedTransactionType == "All" ||
            transaction["transaction_type"] == selectedTransactionType;

        // Date Filter
        final matchesDate = selectedDate == null ||
            DateFormat("yyyy-MM-dd").format(dateTime) ==
                DateFormat("yyyy-MM-dd").format(selectedDate!);

        // Month Filter
        final matchesMonth = selectedMonth == "All" ||
            DateFormat("MMMM").format(dateTime) == selectedMonth;

        return matchesSearch &&
            matchesType &&
            matchesMode &&
            matchesTransactionType &&
            matchesDate &&
            matchesMonth;
      }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      searchQuery = "";
      selectedType = "All";
      selectedMode = "All";
      selectedTransactionType = "All";
      selectedMonth = "All";
      selectedDate = null;
      applyFilters();
    });
  }

  Widget buildFilterRow(ThemeData theme) {
    final isFilterActive = selectedType != "All" ||
        selectedMode != "All" ||
        selectedTransactionType != "All" ||
        selectedMonth != "All" ||
        selectedDate != null;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Type Filter
          buildFilterColumn(
            "Type",
            buildDropdownFilter(
              ["All", "In", "Out"],
              selectedType,
              (value) {
                setState(() {
                  selectedType = value!;
                  applyFilters();
                });
              },
              theme,
            ),
            theme,
          ),
          const SizedBox(width: 8),

          // Mode Filter
          buildFilterColumn(
            "Mode",
            buildDropdownFilter(
              ["All", "Cash", "Online", "Scrap"],
              selectedMode,
              (value) {
                setState(() {
                  selectedMode = value!;
                  applyFilters();
                });
              },
              theme,
            ),
            theme,
          ),
          const SizedBox(width: 8),

          // Transaction Type Filter
          buildFilterColumn(
            "Transaction Type",
            buildDropdownFilter(
              ["All", "Sell", "Expense", "Purchase", "Balance Update"],
              selectedTransactionType,
              (value) {
                setState(() {
                  selectedTransactionType = value!;
                  applyFilters();
                });
              },
              theme,
            ),
            theme,
          ),
          const SizedBox(width: 8),

          // Month Filter
          buildFilterColumn(
            "Month",
            buildDropdownFilter(
              [
                "All",
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"
              ],
              selectedMonth,
              (value) {
                setState(() {
                  selectedMonth = value!;
                  applyFilters();
                });
              },
              theme,
            ),
            theme,
          ),
          const SizedBox(width: 8),

          // Date Filter
          buildFilterColumn(
            "Date",
            IconButton(
              icon: Icon(Icons.date_range, color: theme.primaryColor, size: 20),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    applyFilters();
                  });
                }
              },
            ),
            theme,
          ),
          const SizedBox(width: 8),

          // Conditionally Render Clear Filters Icon Button
          if (isFilterActive)
            IconButton(
              icon: Icon(Icons.clear, color: theme.primaryColor, size: 24),
              tooltip: "Clear Filters",
              onPressed: clearFilters,
            ),
        ],
      ),
    );
  }

  Widget buildFilterColumn(String label, Widget child, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget buildDropdownFilter(List<String> options, String selectedValue,
      ValueChanged<String?> onChanged, ThemeData theme) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(8),
        color: theme.cardColor,
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor, size: 18),
        isDense: true,
        dropdownColor: theme.cardColor,
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Center(
              child: Text(
                option,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> groupTransactionsByMonth() {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var transaction in filteredTransactions) {
      // Parse the custom date format
      final date = DateFormat("yyyy-MM-dd h:mm a").parse(transaction["date"]);

      // Format the month and year
      final monthYear = DateFormat.yMMMM().format(date);

      if (!grouped.containsKey(monthYear)) {
        grouped[monthYear] = [];
      }
      grouped[monthYear]!.add(transaction);
    }

    // Sort the map keys in descending order by date
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        // Convert monthYear keys back to DateTime for comparison
        final dateA = DateFormat.yMMMM().parse(a);
        final dateB = DateFormat.yMMMM().parse(b);
        return dateB.compareTo(dateA); // Descending order
      });

    // Create a sorted map
    final sortedGrouped = {
      for (var key in sortedKeys) key: grouped[key]!,
    };

    return sortedGrouped;
  }

  Widget buildMonthHeader(String monthYear, int totalAmount, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05), // Softer background color
        border: Border(
          bottom: BorderSide(
              color: theme.dividerColor, width: 1), // Subtle separator
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Month-Year Text
          Flexible(
            child: Text(
              monthYear,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, // Less bold
                color: theme.primaryColor,
                fontSize: 16, // Smaller font size
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow
            ),
          ),

          // Total Amount Text
          Text(
            "₹$totalAmount",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600, // Less bold
              color: theme.primaryColor,
              fontSize: 16, // Smaller font size
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionCard(
      Map<String, dynamic> transaction, ThemeData theme, BuildContext context) {
    final isIn = transaction["type"] == "In";

    return GestureDetector(
      onTap: () {
        // Navigate to TransactionDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(
              transactionName: transaction["transaction_name"] ?? "Unknown",
              transactionType: transaction["transaction_type"] ?? "Unknown",
              paymentMode: transaction["payment_mode"] ?? "Unknown",
              amount: transaction["amount"].toString(),
              dateTime: transaction["date"] ?? "Unknown",
              transactionId: transaction["transaction_id"] ?? "Unknown",
              referenceId: transaction["reference_id"] ?? "Unknown",
              inOrOut: transaction["type"] ?? "Unknown", // "In" or "Out",
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding:
            const EdgeInsets.all(12), // Reduced padding for a compact design
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Column: Transaction Name and Date
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction["transaction_name"] ?? "",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                      fontSize: 14, // Adjusted size for compact text
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                    maxLines: 1, // Ensure single-line text
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction["date"] ?? "",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontSize: 12, // Smaller font for secondary details
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10), // Spacer between columns

            // Right Column: Amount and Payment Mode
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${transaction["amount"]}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isIn ? Colors.green : Colors.red,
                      fontSize: 14, // Match size for uniformity
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction["payment_mode"] ?? "",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
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
    final groupedTransactions = groupTransactionsByMonth();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
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
                hintText: "Search transactions by name, ID, or amount...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: buildFilterRow(theme),
          ),

          // Transactions List
          Expanded(
            child: ListView(
              children: groupedTransactions.entries.map((entry) {
                final monthYear = entry.key;
                final monthTransactions = entry.value;

                final totalAmount = monthTransactions.fold<int>(
                  0,
                  (sum, transaction) => sum + (transaction["amount"] as int),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full-width Month Header
                    buildMonthHeader(monthYear, totalAmount, theme),

                    // Transactions with padding
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: monthTransactions
                            .map<Widget>((transaction) => buildTransactionCard(
                                transaction, theme, context)) // Pass context
                            .toList(), // Ensure the return type is List<Widget>
                      ),
                    ),
                    const SizedBox(height: 20), // Spacing after each group
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
