import 'package:flutter/material.dart';

class AddDealerScreen extends StatelessWidget {
  const AddDealerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Dealer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dealer Name
            Text(
              "Dealer Name",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter dealer name",
              ),
            ),
            const SizedBox(height: 16),

            // Contact
            Text(
              "Contact",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter contact number",
              ),
            ),
            const SizedBox(height: 16),

            // Address
            Text(
              "Address",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter address",
              ),
            ),
            const SizedBox(height: 24),

            // Save Button Aligned to Right
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Add dealer logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Save Dealer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
