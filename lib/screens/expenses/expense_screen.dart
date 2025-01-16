import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String selectedMode = "All";
  String selectedReason = "All";
  DateTime? selectedDate;
  String selectedMonth = "All";
  List<Map<String, dynamic>> transactions = [
    {
      "amount": 500,
      "payment_mode": "Cash",
      "reason": "Tea",
      "date": "2025-01-12",
      "expenseId": "E101"
    },
    {
      "amount": 1500,
      "payment_mode": "Online",
      "reason": "Transportation",
      "date": "2025-01-10",
      "expenseId": "E102"
    },
    // Add more transactions here
  ];
  List<Map<String, dynamic>> filteredTransactions = [];

  // Filters
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredTransactions = transactions;
  }

  void applyFilters() {
    setState(() {
      filteredTransactions = transactions.where((transaction) {
        final dateTime = DateFormat("yyyy-MM-dd").parse(transaction["date"]);

        final matchesMode = selectedMode == "All" ||
            transaction["payment_mode"] == selectedMode;
        final matchesReason =
            selectedReason == "All" || transaction["reason"] == selectedReason;
        final matchesDate = selectedDate == null ||
            DateFormat("yyyy-MM-dd").format(dateTime) ==
                DateFormat("yyyy-MM-dd").format(selectedDate!);
        final matchesMonth = selectedMonth == "All" ||
            DateFormat("MMMM").format(dateTime) == selectedMonth;

        return matchesMode && matchesReason && matchesDate && matchesMonth;
      }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      selectedMode = "All";
      selectedReason = "All";
      selectedMonth = "All";
      selectedDate = null;
      applyFilters();
    });
  }

  Widget buildFilterRow(ThemeData theme) {
    final isFilterActive = selectedMode != "All" ||
        selectedReason != "All" ||
        selectedDate != null ||
        selectedMonth != "All";

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Mode Filter
          buildFilterColumn(
            "Mode",
            buildDropdownFilter(
              ["All", "Cash", "Online"],
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

          // Reason Filter
          buildFilterColumn(
            "Reason",
            buildDropdownFilter(
              ["All", "Tea", "Transportation", "Scrap", "Home", "Others"],
              selectedReason,
              (value) {
                setState(() {
                  selectedReason = value!;
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

  // Dialog to add an expense
  Future<void> _showAddExpenseDialog() async {
    final _amountController = TextEditingController();
    String _selectedMode = "Cash";
    String _selectedReason = "Tea";
    DateTime _selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add Expense",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Amount Field
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Payment Mode Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedMode,
                  items: ["Cash", "Online"].map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _selectedMode = value ?? "Cash";
                  },
                  decoration: const InputDecoration(
                    labelText: "Payment Mode",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Reason Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedReason,
                  items: ["Tea", "Transportation", "Scrap", "Home", "Others"]
                      .map((reason) {
                    return DropdownMenuItem(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _selectedReason = value ?? "Tea";
                  },
                  decoration: const InputDecoration(
                    labelText: "Reason",
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
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          _selectedDate = pickedDate;
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: "${_selectedDate.toLocal()}".split(' ')[0],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                if (amount != null) {
                  setState(() {
                    transactions.add({
                      "amount": amount,
                      "payment_mode": _selectedMode,
                      "reason": _selectedReason,
                      "date": DateFormat("yyyy-MM-dd").format(_selectedDate),
                    });
                    applyFilters();
                  });
                  Navigator.pop(context);
                } else {
                  // Handle invalid input (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter a valid amount")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddExpenseDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildFilterRow(theme),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  final isDarkMode =
                      Theme.of(context).brightness == Brightness.dark;

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: isDarkMode
                        ? Colors.grey[800]
                        : Colors.white, // Card background color
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left Column: Reason and Date
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction["reason"] ?? "No reason provided",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black, // Reason color
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                transaction["date"] ?? "Unknown date",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade500, // Date color
                                ),
                              ),
                            ],
                          ),
                          // Right Column: Amount and Payment Mode
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹${transaction["amount"]}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: transaction["type"] == "In"
                                      ? (isDarkMode
                                          ? Colors.greenAccent
                                          : Colors.green)
                                      : (isDarkMode
                                          ? Colors.redAccent
                                          : Colors.red), // Amount color
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                transaction["payment_mode"] ?? "Unknown",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode
                                      ? Colors.grey.shade400
                                      : Colors
                                          .grey.shade600, // Payment mode color
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
