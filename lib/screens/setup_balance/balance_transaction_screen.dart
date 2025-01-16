import 'package:flutter/material.dart';

class BalanceTransactionScreen extends StatelessWidget {
  final String balanceId;
  final String type;
  final String reason;
  final double amount;
  final String date;
  final List<Map<String, dynamic>> transactions; // Transactions List

  const BalanceTransactionScreen({
    Key? key,
    required this.balanceId,
    required this.type,
    required this.reason,
    required this.amount,
    required this.date,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Balance Details"),
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
            // Display Balance Details
            _buildBalanceDetails(theme),
            const SizedBox(height: 20),

            
            const SizedBox(height: 10),
            ...transactions.map((transaction) {
              return _buildTransactionCard(
                transactionId: transaction['id'] ?? "N/A",
                amount: (transaction['amount'] as num?)?.toDouble() ?? 0.0,
                mode: transaction['mode'] ?? "N/A",
                date: transaction['date'] ?? "N/A",
                theme: theme,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceDetails(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Balance ID", balanceId, theme),
          _buildDetailRow("Type", type, theme),
          _buildDetailRow("Reason", reason, theme),
          _buildDetailRow("Date", date, theme),
          Text(
            "Amount: ₹${amount.toInt()}",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
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
