import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String transactionName;
  final String transactionType;
  final String paymentMode;
  final String amount;
  final String dateTime;
  final String transactionId;
  final String referenceId;
  final String inOrOut; // "In" or "Out"

  const TransactionDetailScreen({
    Key? key,
    required this.transactionName,
    required this.transactionType,
    required this.paymentMode,
    required this.amount,
    required this.dateTime,
    required this.transactionId,
    required this.referenceId,
    required this.inOrOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with initial letter and details
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.primaryColor.withOpacity(0.2),
                    child: Text(
                      transactionName.isNotEmpty
                          ? transactionName[0].toUpperCase()
                          : "",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600, // Reduced boldness
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${inOrOut == "In" ? "From" : "To"} $transactionName",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500, // Reduced boldness
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(
                      height: 16), // Added spacing between name and amount
                  Text(
                    "₹$amount",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500, // Reduced boldness
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      transactionType,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400, // Removed boldness
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            paymentMode == "Cash"
                                ? Icons.account_balance_wallet
                                : Icons.credit_card,
                            color: paymentMode == "Cash"
                                ? Colors.green
                                : Colors.blue, // Changed color for online
                          ),
                          const SizedBox(width: 8),
                          Text(
                            paymentMode,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 8,
                        thickness: 1,
                        indent: 80,
                        endIndent: 80,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateTime,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Transaction Details Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transaction ID",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transactionId,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const Divider(height: 24),
                    Text(
                      "Reference ID",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      referenceId,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
