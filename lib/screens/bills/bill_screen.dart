import 'package:flutter/material.dart';

class BillScreen extends StatefulWidget {
  final String billId;
  final String products;
  final String name;
  final String contact;
  final double totalAmount;
  final double paidAmount;
  final String date;
  final List<Map<String, dynamic>> transactions; // Transactions List

  const BillScreen({
    Key? key,
    required this.billId,
    required this.products,
    required this.name,
    required this.contact,
    required this.totalAmount,
    required this.paidAmount,
    required this.date,
    required this.transactions,
  }) : super(key: key);

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late List<Map<String, dynamic>> _paymentFields;

  @override
  void initState() {
    super.initState();
    _initializeEmptyPaymentFields();
  }

  void _initializeEmptyPaymentFields() {
    // Initialize an empty payment field list
    _paymentFields = [];
  }

  void _addPaymentField() {
    setState(() {
      _paymentFields.add({
        "id": "T${_paymentFields.length + 1}",
        "amountController": TextEditingController(),
        "mode": "Cash",
      });
    });
  }

  void _removePaymentField(int index) {
    setState(() {
      _paymentFields.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPaid = widget.paidAmount >= widget.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill Details"),
        backgroundColor:
            theme.brightness == Brightness.light ? Colors.white : Colors.black,
        foregroundColor:
            theme.brightness == Brightness.light ? Colors.black : Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Bill Details
            _buildBillDetails(theme, isPaid),
            const SizedBox(height: 20),

            // Transactions Section
            ...widget.transactions.map((transaction) {
              return _buildTransactionCard(
                transactionId: transaction['id'] ?? "N/A",
                amount: (transaction['amount'] as num?)?.toDouble() ?? 0.0,
                mode: transaction['mode'] ?? "N/A",
                date: transaction['date'] ?? "N/A",
                theme: theme,
              );
            }).toList(),
            const SizedBox(height: 20),

            // Add Payment Section
            isPaid
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "All payments have been made.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _buildAddPaymentSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetails(ThemeData theme, bool isPaid) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Bill ID", widget.billId, theme),
          _buildDetailRow("Products", widget.products, theme),
          _buildDetailRow("Name", widget.name, theme),
          _buildDetailRow("Contact", widget.contact, theme),
          _buildDetailRow("Date", widget.date, theme),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ₹${widget.totalAmount.toInt()}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              Text(
                isPaid
                    ? "Paid: ₹${widget.paidAmount.toInt()}"
                    : "Pending: ₹${(widget.totalAmount - widget.paidAmount).toInt()}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPaid ? Colors.green : Colors.red,
                ),
              ),
              
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildTransactionCard({
    required String transactionId,
    required double amount,
    required String mode,
    required String date,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Left Section (Transaction ID and Mode)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transaction ID: $transactionId",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Truncate if too long
                ),
                const SizedBox(height: 5),
                Text(
                  "Mode: $mode",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Right Section (Amount and Date)
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${amount.toInt()}",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
                const SizedBox(height: 5),
                Text(
                  "$date",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPaymentSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Payment",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: theme.primaryColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blue),
              onPressed: _addPaymentField,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._paymentFields.asMap().entries.map((entry) {
          final index = entry.key;
          final field = entry.value;
          return Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: field['amountController'],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100, // Fixed width for the dropdown
                    child: DropdownButtonFormField<String>(
                      value: field['mode'],
                      items: const [
                        DropdownMenuItem(value: "Cash", child: Text("Cash")),
                        DropdownMenuItem(
                            value: "Online", child: Text("Online")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          field['mode'] = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Mode",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removePaymentField(index),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Space between payment fields
            ],
          );
        }).toList(),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Submit payment logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Submit Payments"),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
