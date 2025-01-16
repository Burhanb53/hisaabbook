import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({Key? key}) : super(key: key);

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _productsController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String _billId = '';
  bool _isPaid = true;
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _paymentFields = [
    {'amountController': TextEditingController(), 'mode': 'Cash'}
  ];

  @override
  void initState() {
    super.initState();
    _generateBillId();
  }

  void _generateBillId() {
    final now = DateTime.now();
    setState(() {
      // Using date, time, and milliseconds to generate a unique Bill ID
      _billId =
          '${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}${now.millisecond}';
    });
  }

  void _addPaymentField() {
    setState(() {
      _paymentFields
          .add({'amountController': TextEditingController(), 'mode': 'Cash'});
    });
  }

  void _removePaymentField(int index) {
    setState(() {
      _paymentFields.removeAt(index);
    });
  }

  void _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Add Sells"),
        backgroundColor:
            theme.brightness == Brightness.light ? Colors.white : Colors.black,
        foregroundColor:
            theme.brightness == Brightness.light ? Colors.black : Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Add spacing on top
            const SizedBox(height: 20),

            // Bill ID (Non-editable field)
            TextField(
              controller: TextEditingController(text: _billId),
              readOnly: true,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: "Bill ID",
                labelStyle: TextStyle(
                  color: theme.hintColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.hintColor!),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Paid/Unpaid Toggle with improved design
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text(
                    "Paid",
                    style: TextStyle(
                      color: _isPaid
                          ? Colors.white
                          : theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  avatar: _isPaid
                      ? const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                  selected: _isPaid,
                  selectedColor: Colors.greenAccent,
                  backgroundColor: theme.cardColor,
                  onSelected: (selected) {
                    setState(() {
                      _isPaid = true;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: Text(
                    "Unpaid",
                    style: TextStyle(
                      color: !_isPaid
                          ? Colors.white
                          : theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  avatar: !_isPaid
                      ? const Icon(
                          Icons.cancel,
                          size: 16,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.cancel_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                  selected: !_isPaid,
                  selectedColor: Colors.redAccent,
                  backgroundColor: theme.cardColor,
                  onSelected: (selected) {
                    setState(() {
                      _isPaid = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Paid Fields
            if (_isPaid) _buildPaidFields(theme),

            // Unpaid Fields
            if (!_isPaid) _buildUnpaidFields(theme),

            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  "Save Sale",
                  style: TextStyle(
                    color: theme.brightness == Brightness.light
                        ? Colors.white
                        : theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaidFields(ThemeData theme) {
    return Column(
      children: [
        TextField(
          controller: _productsController,
          decoration: const InputDecoration(
            labelText: "Products",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: "Date",
              border: OutlineInputBorder(),
            ),
            child: Text(
              DateFormat('dd-MM-yyyy')
                  .format(_selectedDate), // Updated date format
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _totalAmountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Total Amount",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),

        // Payment Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Payment", style: TextStyle(fontSize: 16)),
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
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 100, // Fixed width for the dropdown
                    child: DropdownButtonFormField<String>(
                      value: field['mode'],
                      items: const [
                        DropdownMenuItem(value: "Cash", child: Text("Cash")),
                        DropdownMenuItem(
                            value: "Online", child: Text("Online")),
                        DropdownMenuItem(value: "Scrap", child: Text("Scrap")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          field['mode'] = value;
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
      ],
    );
  }

  Widget _buildUnpaidFields(ThemeData theme) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Name",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: "Contact",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _productsController,
          decoration: const InputDecoration(
            labelText: "Products",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: "Date",
              border: OutlineInputBorder(),
            ),
            child: Text(
              DateFormat('dd-MM-yyyy')
                  .format(_selectedDate), // Updated date format
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _totalAmountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Total Amount",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),

        // Payment Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Payment", style: TextStyle(fontSize: 16)),
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
                    width: 80, // Fixed width for the dropdown
                    child: DropdownButtonFormField<String>(
                      value: field['mode'],
                      items: const [
                        DropdownMenuItem(value: "Cash", child: Text("Cash")),
                        DropdownMenuItem(
                            value: "Online", child: Text("Online")),
                        DropdownMenuItem(value: "Scrap", child: Text("Scrap")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          field['mode'] = value;
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
      ],
    );
  }
}
