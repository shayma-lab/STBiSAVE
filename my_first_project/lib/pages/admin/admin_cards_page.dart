import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_first_project/models/category.dart';
import 'package:my_first_project/services/category.dart';

class AdminCardsPage extends StatefulWidget {
  const AdminCardsPage({super.key});

  @override
  State<AdminCardsPage> createState() => _AdminCardsPageState();
}

class _AdminCardsPageState extends State<AdminCardsPage> {
  List<Category> categories = [];
  Category? selectedCategory;
  bool isLoading = false;
  List<Map<String, dynamic>> users = [];
  Map<String, dynamic>? selectedUser;
  Map<String, dynamic>? userCard;
  List<Map<String, dynamic>> transactions = [];

  final TextEditingController soldeController = TextEditingController();
  final TextEditingController numeroCarteController = TextEditingController();
  final TextEditingController typeCarteController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();

  final apiUrl = dotenv.env['API_URL'];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchCategories();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/admin/users'));

      if (response.statusCode == 200) {
        final List<dynamic> userList = json.decode(response.body);
        setState(() {
          users = userList.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Erreur lors du chargement des utilisateurs');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      setState(() {
        isLoading = true;
      });
      CategoryService categoryService = CategoryService();
      categories = await categoryService.getAllCategoriesByUser();
    } catch (e) {
      print('Erreur: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserCard(String userId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/admin/card/$userId'));

      if (response.statusCode == 200) {
        final card = json.decode(response.body);
        userCard = card;

        soldeController.text = card['soldeBancaire'].toString();
        numeroCarteController.text = card['numeroCarte'];
        typeCarteController.text = card['typeCarte'];
        expirationController.text = card['dateExpiration'];

        await fetchTransactions(card['_id']);
      } else if (response.statusCode == 404) {
        userCard = null;
        soldeController.clear();
        numeroCarteController.clear();
        typeCarteController.clear();
        expirationController.clear();
        transactions = [];
      } else {
        throw Exception("Erreur lors de la récupération de la carte");
      }
    } catch (e) {
      print("Erreur fetchUserCard: $e");
    }
  }

  Future<void> fetchTransactions(String cardId) async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/admin/transactions/$cardId'));

      if (response.statusCode == 200) {
        final List<dynamic> transactionList = json.decode(response.body);
        setState(() {
          transactions = transactionList.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception("Erreur lors de la récupération des transactions");
      }
    } catch (e) {
      print("Erreur fetchTransactions: $e");
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      final response = await http
          .delete(Uri.parse('$apiUrl/admin/delete-transaction/$transactionId'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction supprimée ✅")),
        );
        await fetchTransactions(userCard!['_id']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la suppression.")),
        );
      }
    } catch (e) {
      print("Erreur deleteTransaction: $e");
    }
  }

  Future<void> submitCard() async {
    final solde = soldeController.text;
    final numero = numeroCarteController.text;
    final type = typeCarteController.text;
    final expiration = expirationController.text;

    if ([solde, numero, type, expiration].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs sont obligatoires")),
      );
      return;
    }

    final body = {
      "userId": selectedUser!['_id'],
      "soldeBancaire": solde,
      "numeroCarte": numero,
      "typeCarte": type,
      "dateExpiration": expiration,
    };

    final isUpdate = userCard != null;
    final url = isUpdate ? '$apiUrl/admin/add-card' : '$apiUrl/admin/add-card';

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Carte ${isUpdate ? 'mise à jour' : 'ajoutée'} pour ${selectedUser!['name']} ✅")),
      );
      setState(() {
        selectedUser = null;
        userCard = null;
        transactions = [];
      });
      soldeController.clear();
      numeroCarteController.clear();
      typeCarteController.clear();
      expirationController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'enregistrement.")),
      );
    }
  }

  Future<void> addTransaction(String number, String amount, String beneficiary,
      String categoryId) async {
    final body = {
      "userId": selectedUser!['_id'],
      "cardId": userCard!['_id'],
      "transactionNumber": number,
      "amount": amount,
      "beneficiaryAccount": beneficiary,
      "category": categoryId,
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/admin/add-transaction'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction ajoutée ✅")),
        );
        await fetchTransactions(userCard!['_id']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Erreur lors de l'ajout de la transaction.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'ajout.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "💳 Admin - Gestion des cartes",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selectedUser == null ? _buildUserList() : _buildCardForm(),
      ),
    );
  }

  Widget _buildUserList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sélectionnez un utilisateur :",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text("${user['name']} ${user['prenom']}"),
                      subtitle: Text("ID: ${user['_id']}"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        setState(() => selectedUser = user);
                        await fetchUserCard(user['_id']);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCardForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "Utilisateur sélectionné : ${selectedUser!['name']} ${selectedUser!['prenom']}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          TextField(
            controller: soldeController,
            decoration: const InputDecoration(
                labelText: "Solde bancaire (DT)", border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: numeroCarteController,
            decoration: const InputDecoration(
                labelText: "Numéro de carte", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: typeCarteController,
            decoration: const InputDecoration(
                labelText: "Type de carte (ex: Visa, MasterCard)",
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: expirationController,
            decoration: const InputDecoration(
                labelText: "Date d'expiration (MM/AA)",
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    selectedUser = null;
                    userCard = null;
                    transactions = [];
                  }),
                  child: const Text("🔙 Retour"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: submitCard,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child:
                      Text(userCard == null ? "✅ Ajouter" : "♻️ Mettre à jour"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _showAddTransactionDialog,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("➕ Ajouter une transaction"),
          ),
          const SizedBox(height: 20),
          const Text("📜 Liste des transactions :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...transactions.map((t) => Card(
                child: ListTile(
                  leading: const Icon(Icons.payment),
                  title: Text("Transaction #${t['transactionNumber']}"),
                  subtitle: Text(
                      "Montant: ${t['amount']} DT\nBénéficiaire: ${t['beneficiaryAccount']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t['date'].toString().substring(0, 10)),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirmer la suppression"),
                              content: const Text(
                                  "Voulez-vous vraiment supprimer cette transaction ?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Annuler"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteTransaction(t['_id']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text("Supprimer"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )),
          if (transactions.isEmpty)
            const Text("Aucune transaction trouvée.",
                style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _showAddTransactionDialog() {
    final transactionNumberController = TextEditingController();
    final amountController = TextEditingController();
    final beneficiaryController = TextEditingController();
    Category? dialogSelectedCategory = selectedCategory;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Ajouter une transaction"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: transactionNumberController,
                    decoration: const InputDecoration(
                        labelText: "Numéro de transaction"),
                  ),
                  TextField(
                    controller: amountController,
                    decoration:
                        const InputDecoration(labelText: "Montant (DT)"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: beneficiaryController,
                    decoration:
                        const InputDecoration(labelText: "Compte bénéficiaire"),
                  ),
                  DropdownButton<Category>(
                    value: dialogSelectedCategory,
                    hint: const Text("Sélectionnez une catégorie"),
                    items: categories.map((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.title),
                      );
                    }).toList(),
                    onChanged: (Category? value) {
                      setState(() {
                        dialogSelectedCategory = value;
                      });
                    },
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (dialogSelectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Veuillez sélectionner une catégorie")),
                      );
                      return;
                    }

                    await addTransaction(
                      transactionNumberController.text,
                      amountController.text,
                      beneficiaryController.text,
                      dialogSelectedCategory!.id,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Ajouter"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
