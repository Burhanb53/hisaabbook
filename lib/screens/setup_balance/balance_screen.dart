import 'package:flutter/material.dart';
import 'balance_transaction_screen.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  double _cashAmount = 500000.0; // Example default value
  double _onlineAmount = 2500.0; // Example default value

  List<Map<String, dynamic>> _balanceHistory = [
    {
      "type": "Cash",
      "reason": "Sales",
      "amount": 15000.0,
      "date": "2024-11-15"
    },
    {
      "type": "Online",
      "reason": "UPI Transfer",
      "amount": 10000.0,
      "date": "2024-11-14"
    },
    {"type": "Cash", "reason": "Misc", "amount": 5000.0, "date": "2024-11-13"},
    {
      "type": "Online",
      "reason": "Refund",
      "amount": 2500.0,
      "date": "2024-11-12"
    },
    {
      "type": "Cash",
      "reason": "Sales",
      "amount": 15000.0,
      "date": "2024-11-15"
    },
    {
      "type": "Online",
      "reason": "UPI Transfer",
      "amount": 10000.0,
      "date": "2024-11-14"
    },
    {"type": "Cash", "reason": "Misc", "amount": 5000.0, "date": "2024-11-13"},
    {
      "type": "Online",
      "reason": "Refund",
      "amount": 2500.0,
      "date": "2024-11-12"
    },
  ];

  List<Map<String, dynamic>> _filteredHistory = [];
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _filteredHistory = List.from(_balanceHistory);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;

      if (filter == "All") {
        _filteredHistory = List.from(_balanceHistory);
      } else if (filter == "Cash" || filter == "Online") {
        _filteredHistory =
            _balanceHistory.where((item) => item['type'] == filter).toList();
      } else if (filter == "Date") {
        _selectDateFilter();
      }
    });
  }

  void _selectDateFilter() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _filteredHistory = _balanceHistory.where((item) {
          return item['date'] == selectedDate.toString().split(' ')[0];
        }).toList();
      });
    }
  }

  void _showAddBalanceDialog() {
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _reasonController = TextEditingController();
    String selectedType = "Cash";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Add Balance"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(value: "Cash", child: Text("Cash")),
                  DropdownMenuItem(value: "Online", child: Text("Online")),
                ],
                onChanged: (value) {
                  selectedType = value!;
                },
                decoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_amountController.text.isNotEmpty &&
                    _reasonController.text.isNotEmpty) {
                  setState(() {
                    double addedAmount =
                        double.tryParse(_amountController.text)?.toDouble() ??
                            0;

                    _balanceHistory.add({
                      "type": selectedType,
                      "reason": _reasonController.text,
                      "amount": addedAmount,
                      "date": DateTime.now().toString().split(' ')[0],
                    });

                    if (selectedType == "Cash") {
                      _cashAmount += addedAmount;
                    } else {
                      _onlineAmount += addedAmount;
                    }
                  });
                  Navigator.of(context).pop();
                  _applyFilter(_selectedFilter); // Reapply filter
                }
              },
              child: const Text("Add Balance"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required ThemeData theme,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String type,
    required String reason,
    required double amount,
    required String date,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BalanceTransactionScreen(
              balanceId:
                  "B12345", // You can pass the balance ID dynamically if available
              type: type,
              reason: reason,
              amount: amount,
              date: date,
              transactions: [
                // Example transactions; replace with actual transactions
                {
                  "id": "T001789255892",
                  "amount": amount,
                  "mode": "Cash",
                  "date": "23/11/2024"
                },
              ],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  reason,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${amount.toInt()}", // Display as integer
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => _applyFilter("All"),
          child: const Text("All"),
          style: TextButton.styleFrom(
            foregroundColor:
                _selectedFilter == "All" ? theme.primaryColor : theme.hintColor,
          ),
        ),
        TextButton(
          onPressed: () => _applyFilter("Date"),
          child: const Text("Date"),
          style: TextButton.styleFrom(
            foregroundColor: _selectedFilter == "Date"
                ? theme.primaryColor
                : theme.hintColor,
          ),
        ),
        TextButton(
          onPressed: () => _applyFilter("Cash"),
          child: const Text("Cash"),
          style: TextButton.styleFrom(
            foregroundColor: _selectedFilter == "Cash"
                ? theme.primaryColor
                : theme.hintColor,
          ),
        ),
        TextButton(
          onPressed: () => _applyFilter("Online"),
          child: const Text("Online"),
          style: TextButton.styleFrom(
            foregroundColor: _selectedFilter == "Online"
                ? theme.primaryColor
                : theme.hintColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Balance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: "Cash",
                    value: "₹${_cashAmount.toInt()}", // Display as integer
                    icon: Icons.attach_money,
                    theme: theme,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    title: "Online",
                    value: "₹${_onlineAmount.toInt()}", // Display as integer
                    icon: Icons.online_prediction,
                    theme: theme,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // // Initial Amounts Fields (Non-editable)
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: TextEditingController(
            //             text: "₹${_cashAmount.toStringAsFixed(0)}"),
            //         readOnly: true,
            //         decoration: const InputDecoration(
            //           labelText: "Initial Cash Amount",
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 10),
            //     Expanded(
            //       child: TextField(
            //         controller: TextEditingController(
            //             text: "₹${_onlineAmount.toStringAsFixed(0)}"),
            //         readOnly: true,
            //         decoration: const InputDecoration(
            //           labelText: "Initial Online Amount",
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Balance History",
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showAddBalanceDialog,
                  child: const Text("Add Balance"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildFilterRow(theme),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredHistory.length,
                itemBuilder: (context, index) {
                  final item = _filteredHistory[index];
                  return _buildHistoryCard(
                    type: item['type'],
                    reason: item['reason'],
                    amount: item['amount'],
                    date: item['date'],
                    theme: theme,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
