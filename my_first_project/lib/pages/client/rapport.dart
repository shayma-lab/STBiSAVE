import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_project/models/transaction.dart';
import 'package:my_first_project/models/transactionByCategory.dart';
import 'package:my_first_project/services/transactions.dart';
import 'package:my_first_project/widgets/appbar_widget.dart';
import 'package:my_first_project/widgets/barchart_widget.dart';
import 'package:my_first_project/widgets/circular_widget.dart';
import 'package:my_first_project/widgets/error_message_widget.dart';
import 'package:my_first_project/widgets/info_message_widget.dart';

class RapportsPage extends StatefulWidget {
  static const routeName = "/RapportsPage";
  const RapportsPage({super.key});

  @override
  State<RapportsPage> createState() => _RapportsPageState();
}

class _RapportsPageState extends State<RapportsPage> {
  bool isLoading = false;
  String errorMessage = "";
  TransactionService transactionService = TransactionService();
  List<TransactionByCategory> transactions = [];
  List<TransactionByCategory> limitedTransactions = [];
  Map<String, dynamic> monthlySummary = {};

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
      final data = await transactionService.getTransactionsByCategory();
      monthlySummary = await transactionService.getMonthlyTransactions();
      print(monthlySummary);
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
    return Scaffold(
      appBar: appBar(context, "Rapports & Statistiques"),
      body: SafeArea(
        child: isLoading
            ? CircularWidget(Colors.white)
            : errorMessage != ""
                ? ErrorMessageWidget(errorMessage)
                : transactions.isEmpty
                    ? InfoMessageWidget("Aucun transactions trouvé !")
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'Résumé des dépenses mensuelles',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(
                                  'Total des dépenses : ${monthlySummary['totalAmount'].toStringAsFixed(2)} DT',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Nombre de transactions : ${monthlySummary['count']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
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
                            ...transactions.map((cat) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: Icon(cat.category.icon,
                                      color: cat.category.color),
                                  title: Text(cat.category.title),
                                  trailing: Text(
                                    '-${cat.totalAmount.toStringAsFixed(2)} DT',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  onTap: () =>
                                      showTransactions(cat.transactions),
                                ),
                              );
                            }),
                          ],
                        ),
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
