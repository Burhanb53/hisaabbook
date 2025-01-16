import 'package:flutter/material.dart';

class PurchaseBillScreen extends StatefulWidget {
  final String billId;
  final String pdfUrl;
  final String date;
  final double totalAmount;
  final List<Map<String, dynamic>> transactions;

  const PurchaseBillScreen({
    Key? key,
    this.billId = "B12345",
    this.pdfUrl = "https://example.com/sample-bill.pdf",
    this.date = "2025-01-15",
    this.totalAmount = 5000.0,
    this.transactions = const [
      {
        "id": "T1",
        "amount": 2000.0,
        "mode": "Cash",
        "date": "2025-01-10",
      },
      {
        "id": "T2",
        "amount": 1500.0,
        "mode": "Online",
        "date": "2025-01-12",
      },
    ],
  }) : super(key: key);

  @override
  _PurchaseBillScreenState createState() => _PurchaseBillScreenState();
}

class _PurchaseBillScreenState extends State<PurchaseBillScreen> {
  late List<Map<String, dynamic>> _paymentFields;

  @override
  void initState() {
    super.initState();
    _initializeEmptyPaymentFields();
  }

  void _initializeEmptyPaymentFields() {
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
            _buildBillDetails(theme),
            const SizedBox(height: 20),
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
            _buildAddPaymentSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetails(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bill ID
          _buildDetailRow("Bill ID", widget.billId, theme),
          const Divider(
              height: 24, color: Colors.grey), // Divider for better separation

          // View Bill PDF Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle PDF view action
                print("View PDF: ${widget.pdfUrl}");
              },
              icon: Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
              label: Text(
                "View Bill PDF",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600], // Grey color for both themes
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor:
                    Colors.grey[800], // Soft grey shadow for both themes
                elevation: 4,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Date
          _buildDetailRow("Date", widget.date, theme),
          const SizedBox(height: 16),

          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount:",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "₹${widget.totalAmount.toInt()}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Utility function for reusable detail rows
  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.hintColor,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ],
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
                  overflow: TextOverflow.ellipsis,
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
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                    width: 100,
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
              const SizedBox(height: 10),
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
}
