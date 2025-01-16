import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bill_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Map<String, dynamic>> sales = [
    {
      "bill_id": "B001",
      "products": "Product 1, Product 2",
      "payment": "Paid",
      "total_amount": 5000,
      "date": "2024-09-15",
    },
    {
      "bill_id": "B002",
      "products": "Product 3, Product 4",
      "payment": "Unpaid",
      "total_amount": 7000,
      "date": "2024-09-14",
    },
    {
      "bill_id": "B003",
      "products": "Product 5, Product 6",
      "payment": "Paid",
      "total_amount": 3000,
      "date": "2024-10-01",
    },
    {
      "bill_id": "B004",
      "products": "Product 7, Product 8",
      "payment": "Unpaid",
      "total_amount": 8000,
      "date": "2024-10-05",
    },
    {
      "bill_id": "B005",
      "products": "Product 9",
      "payment": "Paid",
      "total_amount": 10000,
      "date": "2024-10-10",
    },
  ];

  List<Map<String, dynamic>> filteredSales = [];
  String searchQuery = "";
  String selectedPaymentStatus = "All";
  String selectedMonth = "All";
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    filteredSales = List.from(sales);
  }

  void applyFilters() {
    setState(() {
      filteredSales = sales.where((sale) {
        final matchesSearch = searchQuery.isEmpty ||
            sale["bill_id"].toLowerCase().contains(searchQuery.toLowerCase()) ||
            sale["total_amount"].toString().contains(searchQuery);

        final matchesPayment = selectedPaymentStatus == "All" ||
            sale["payment"] == selectedPaymentStatus;

        final matchesMonth = selectedMonth == "All" ||
            DateFormat('MMMM')
                    .format(DateFormat("yyyy-MM-dd").parse(sale["date"])) ==
                selectedMonth;

        final matchesDate = selectedDate == null ||
            DateFormat("yyyy-MM-dd").format(
                  DateFormat("yyyy-MM-dd").parse(sale["date"]),
                ) ==
                DateFormat("yyyy-MM-dd").format(selectedDate!);

        return matchesSearch && matchesPayment && matchesMonth && matchesDate;
      }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      searchQuery = "";
      selectedPaymentStatus = "All";
      selectedMonth = "All";
      selectedDate = null;
      filteredSales = List.from(sales);
    });
  }

  Map<String, Map<String, List<Map<String, dynamic>>>>
      groupSalesByMonthAndDate() {
    Map<String, Map<String, List<Map<String, dynamic>>>> grouped = {};

    for (var sale in filteredSales) {
      final date = DateFormat("yyyy-MM-dd").parse(sale["date"]);
      final monthYear = DateFormat.yMMMM().format(date);
      final dayDate = DateFormat.yMMMd().format(date);

      if (!grouped.containsKey(monthYear)) {
        grouped[monthYear] = {};
      }

      if (!grouped[monthYear]!.containsKey(dayDate)) {
        grouped[monthYear]![dayDate] = [];
      }

      grouped[monthYear]![dayDate]!.add(sale);
    }

    // Sort months in descending order by date
    final sortedMonthKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat.yMMMM().parse(a);
        final dateB = DateFormat.yMMMM().parse(b);
        return dateB.compareTo(dateA); // Descending order
      });

    final sortedGrouped = {
      for (var month in sortedMonthKeys)
        month: {
          // Sort dates within each month in descending order
          for (var date in (grouped[month]!.entries.toList()
            ..sort((a, b) {
              final dateA = DateFormat.yMMMd().parse(a.key);
              final dateB = DateFormat.yMMMd().parse(b.key);
              return dateB.compareTo(dateA);
            }))) // Corrected closing parenthesis here
            date.key: date.value,
        }
    };

    return sortedGrouped;
  }


  Widget buildDateHeader(String date, int totalAmount, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.03),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.primaryColor,
            ),
          ),
          Text(
            "₹$totalAmount",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }



  Widget buildSalesCard(
      Map<String, dynamic> sale, ThemeData theme, BuildContext context) {
    final isPaid = sale["payment"] == "Paid";

    return GestureDetector(
      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BillScreen(
        billId: "B001", // Dummy Bill ID
        products: "Product A, Product B", // Dummy product list
        name: "Jane Doe", // Dummy name
        contact: "1234567890", // Dummy contact
        totalAmount: 10000, // Dummy total amount
        paidAmount: 5000, // Dummy paid amount
        date: "2024-12-01", // Dummy date
        transactions: [
          {"id": "T001123456", "amount": 2000, "mode": "Cash", "date": "2024-12-01"},
          {"id": "T002654321", "amount": 3000, "mode": "Online", "date": "2024-12-02"},
        ], // Dummy transactions
      ),
    ),
  );
},

child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
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
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bill ID: ${sale["bill_id"]}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Products: ${sale["products"]}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                    "₹${sale["total_amount"]}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPaid ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sale["date"],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterRow(ThemeData theme) {
    final isFilterActive = searchQuery.isNotEmpty ||
        selectedPaymentStatus != "All" ||
        selectedMonth != "All" ||
        selectedDate != null;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Payment Status Filter
          buildFilterColumn(
            "Payment Status",
            buildDropdownFilter(
              ["All", "Paid", "Unpaid"],
              selectedPaymentStatus,
              (value) {
                setState(() {
                  selectedPaymentStatus = value!;
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
        items: options
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Center(
                    child: Text(
                      option,
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget buildMonthHeader(String monthYear, int totalAmount, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            monthYear,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
          Text(
            "₹$totalAmount",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedSales = groupSalesByMonthAndDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales"),
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
                hintText: "Search by Bill ID or Amount...",
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

          // Sales List
          Expanded(
            child: ListView(
              children: groupedSales.entries.map((monthEntry) {
                final monthYear = monthEntry.key;
                final dateGroups = monthEntry.value;

                final totalAmountForMonth = dateGroups.values.fold<int>(
  0,
  (sum, sales) => sum +
      sales.fold<int>(
          0, (dateSum, sale) => dateSum + (sale["total_amount"] as int)),
);


                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month Header
                    buildMonthHeader(monthYear, totalAmountForMonth, theme),

                    // Date Groups
                    ...dateGroups.entries.map((dateEntry) {
                      final date = dateEntry.key;
                      final sales = dateEntry.value;

                      final totalAmountForDate = sales.fold<int>(
                        0,
                        (sum, sale) => sum + (sale["total_amount"] as int),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header
                          buildDateHeader(date, totalAmountForDate, theme),

                          // Sales Cards for the Date
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: sales
                                  .map<Widget>((sale) =>
                                      buildSalesCard(sale, theme, context))
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    }).toList(),

                    const SizedBox(height: 20),
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
