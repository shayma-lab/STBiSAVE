import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_project/models/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'rapport.dart';
import 'objectif.dart';
import 'profile.dart';

class AcceuilPage extends StatefulWidget {
  const AcceuilPage({Key? key});

  @override
  State<AcceuilPage> createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
  UserData userData = UserData(name: "", solde: 0.0, transactions: []);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // on charge les données depuis l’API avec token
  }

  // Récupérer le token depuis SharedPreferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // Récupérer les données utilisateur via API
  Future<void> fetchUserData() async {
    final token = await _getToken();
    setState(() {
      isLoading = true;
    });
    try {
      if (token.isEmpty) throw Exception('Token non trouvé');

      final response = await http.get(
        Uri.parse('http://localhost:5000/api/auth/me'), // ton backend
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          userData = UserData.fromJson(jsonData);
        });
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (error) {
      print("Erreur : $error");
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
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
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
                                'Bienvenue, ${userData.name}',
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
                                  '${userData.solde.toStringAsFixed(3)} DT',
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
                    itemCount: userData.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = userData.transactions[index];
                      return TransactionTile(
                        title: transaction.title,
                        amount:
                            '${transaction.amount >= 0 ? '+' : ''}${transaction.amount.toStringAsFixed(2)} DT',
                        date: transaction.date,
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
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const RapportsPage()));
          } else if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ObjectifPage()));
          } else if (index == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ProfilePage()));
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

