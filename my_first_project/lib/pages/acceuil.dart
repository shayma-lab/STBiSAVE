import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_first_project/models/transactionWithUser.dart';
import 'package:my_first_project/models/user.dart';
import 'package:my_first_project/services/auth.dart';
import 'rapport.dart';
import 'objectif.dart';
import 'profile.dart';

class AcceuilPage extends StatefulWidget {
  const AcceuilPage({Key? key});

  @override
  State<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  bool isLoading = false;
  String errorMessage = "";
  Auth auth = Auth();
  TransactionWithUser transaction = TransactionWithUser(
      UserData("", "", "", "", "", "", DateTime.now(), 0, []), 0, []);

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
      final data = await auth.fetchTransactions();
      setState(() {
        transaction = data;
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
      backgroundColor: const Color(0xFFF3F6FF),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != ""
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
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
                                  const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/logo.png'),
                                    radius: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Bienvenue, ${transaction.user.name}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.notifications_none,
                                  color: Colors.white),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
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
                                      '${transaction.solde.toStringAsFixed(3)} DT',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Transactions récentes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Voir tout',
                            style: TextStyle(color: Colors.blueAccent),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: transaction.transactions.length,
                        itemBuilder: (context, index) {
                          final transactionData = transaction.transactions[index];
                          return TransactionTile(
                            title: transactionData.title,
                            amount:
                                '${transactionData.amount >= 0 ? '+' : ''}${transactionData.amount.toStringAsFixed(2)} DT',
                            date: transactionData.date,
                          );
                        },
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RapportsPage()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ObjectifPage()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartPie),
            label: 'Statistiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Objectifs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Compte',
          ),
        ],
      ),
    );
  }
}

// ===================
// TILE DE TRANSACTION
// ===================
class TransactionTile extends StatefulWidget {
  final String title;
  final String amount;
  final String date;

  const TransactionTile({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
  }) : super(key: key);

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  IconData? selectedIcon;
  Color iconColor = Colors.teal;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Alimentation', 'icon': Icons.fastfood, 'color': Colors.orange},
    {'name': 'Transport', 'icon': Icons.directions_bus, 'color': Colors.blue},
    {'name': 'Loisirs', 'icon': Icons.movie, 'color': Colors.purple},
    {'name': 'Shopping', 'icon': Icons.shopping_cart, 'color': Colors.green},
    {'name': 'Factures', 'icon': Icons.receipt, 'color': Colors.red},
  ];

  void _showCategorySelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sélectionner une catégorie"),
          content: SingleChildScrollView(
            child: Column(
              children: categories.map((category) {
                return ListTile(
                  leading: Icon(category['icon'], color: category['color']),
                  title: Text(category['name']),
                  onTap: () {
                    setState(() {
                      selectedIcon = category['icon'];
                      iconColor = category['color'];
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          selectedIcon ?? Icons.category,
          color: iconColor,
        ),
        title: Text(widget.title),
        subtitle: Text(widget.date),
        trailing: Text(widget.amount),
        onTap: _showCategorySelector,
      ),
    );
  }
}
