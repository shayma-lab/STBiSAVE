import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_project/models/transaction.dart';
import 'package:my_first_project/models/transactionByCategory.dart';
import 'package:my_first_project/services/transactions.dart';
import 'package:my_first_project/widgets/barchart_widget.dart';
import 'package:my_first_project/widgets/circular_widget.dart';
import 'package:my_first_project/widgets/error_message_widget.dart';
import 'package:my_first_project/widgets/info_message_widget.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  bool isLoading = false;
  String errorMessage = "";
  TransactionService transactionService = TransactionService();
  List<TransactionByCategory> transactions = [];
  List<TransactionByCategory> limitedTransactions = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await transactionService.getTransactionsByCategoryAdmin();
      setState(() {
        transactions = data;
        limitedTransactions = transactions.take(5).toList();
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularWidget(Colors.white)
        : errorMessage != ""
            ? ErrorMessageWidget(errorMessage)
            : transactions.isEmpty
                ? InfoMessageWidget("Aucun transactions trouvé !")
                : RefreshIndicator(
                    onRefresh: fetchData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Dépenses des 5 premières catégories',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          BarchartWidget(limitedTransactions),
                          const SizedBox(height: 30),
                          const Text(
                            'Résumé des dépenses',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: Icon(
                                    transaction.category.icon,
                                    color: transaction.category.color,
                                  ),
                                  title: Text(transaction.category.title),
                                  subtitle: Text(
                                    "${transaction.count} transactions",
                                  ),
                                  trailing:
                                      Text(transaction.totalAmount.toString()),
                                  onTap: () => showTransactions(
                                      transaction.transactions),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
  }

  showTransactions(List<Transaction> transactions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Transactions"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Card(
                child: ListTile(
                  title: Text(transaction.beneficiaryAccount),
                  subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a')
                      .format(transaction.date)),
                  trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
