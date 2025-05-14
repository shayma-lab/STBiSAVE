import 'package:flutter/material.dart';
import 'package:my_first_project/models/transaction.dart';
import 'package:my_first_project/models/user.dart';
import 'package:my_first_project/services/auth.dart';
import 'package:my_first_project/services/transactions.dart';
import 'package:my_first_project/widgets/Transaction_tile_wiget.dart';
import 'package:my_first_project/widgets/cachedImageWidget.dart';
import 'package:my_first_project/widgets/circular_widget.dart';
import 'package:my_first_project/widgets/error_message_widget.dart';
import 'package:my_first_project/widgets/info_message_widget.dart';

class AcceuilPage extends StatefulWidget {
  static const routeName = "/AcceuilPage";
  const AcceuilPage({Key? key});

  @override
  State<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  bool isLoading = false;
  String errorMessage = "";
  Auth auth = Auth();
  TransactionService transactionService = TransactionService();
  List<Transaction> transactions = [];
  UserData user = UserData(
      "", "", "", "", "", "", "", DateTime.now(), 0, UserRole.user, "");

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userData = await auth.userData();
    setState(() {
      user = userData;
    });
  }

  Future<void> fetchData() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      final data = await transactionService.fetchTransactions();
      setState(() {
        transactions = data;
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3C8CE7), Color(0xFF00EAFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: CachedImageWidget(
                                user.image, 40, 40, BoxFit.cover)),
                        const SizedBox(width: 10),
                        Text(
                          'Bienvenue, ${user.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/carte.png',
                          width: 100,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Votre solde',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${user.soldeBancaire.toStringAsFixed(3)} DT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Transactions récentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          isLoading
              ? Expanded(child: CircularWidget(Colors.white))
              : errorMessage != ""
                  ? Expanded(child: ErrorMessageWidget(errorMessage))
                  : transactions.isEmpty
                      ? Expanded(
                          child:
                              InfoMessageWidget("Aucun transactions trouvé !"))
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: fetchData,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  return TransactionTile(
                                    transactions[index],
                                    user,
                                    onCategoryChanged: fetchData,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
        ],
      ),
    );
  }
}
