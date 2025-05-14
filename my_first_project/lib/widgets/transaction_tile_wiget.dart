import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_project/models/category.dart';
import 'package:my_first_project/models/transaction.dart';
import 'package:my_first_project/models/user.dart';
import 'package:my_first_project/services/category.dart';

class TransactionTile extends StatefulWidget {
  final Transaction transaction;
  final UserData user;
  final VoidCallback onCategoryChanged;

  const TransactionTile(
    this.transaction,
    this.user, {
    super.key,
    required this.onCategoryChanged,
  });

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  CategoryService categoryService = CategoryService();
  bool isLoading = false;
  List<Category> categories = [];
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      setState(() {
        isLoading = true;
      });
      categories = await categoryService.getAllCategoriesByUser();
    } catch (e) {
      print('Erreur: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showCategorySelector() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sélectionner une catégorie"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: categories.isEmpty
                      ? const Center(child: Text("Aucune catégorie disponible"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(
                                categories[index].icon,
                                color: categories[index].color,
                              ),
                              title: Text(categories[index].title),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteCategory(categories[index].id);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color:
                                      categories[index].userId == widget.user.id
                                          ? Colors.red
                                          : Colors.transparent,
                                ),
                              ),
                              onTap: () async {
                                try {
                                  await categoryService
                                      .updateTransactionCategory(
                                    widget.transaction.id,
                                    categories[index].id,
                                  );
                                  widget.onCategoryChanged();
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  if(mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Erreur: $e"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => newCategoryDialog(),
                        );
                      },
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Ajouter une catégorie",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
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
          widget.transaction.category.icon,
          color: widget.transaction.category.color,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.transaction.beneficiaryAccount),
            Text(
              widget.transaction.category.title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - hh:mm a').format(
            widget.transaction.date,
          ),
        ),
        trailing: Text(widget.transaction.amount.toString()),
        onTap: _showCategorySelector,
      ),
    );
  }

  AlertDialog newCategoryDialog() {
    return AlertDialog(
      title: const Text("Ajouter une nouvelle catégorie"),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: _buildTextField(
              titleController, "Nom de la catégorie", Icons.category),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Annuler"),
        ),
        TextButton(
          onPressed: () {
            addNewCategory();
          },
          child: const Text("Ajouter"),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF005A9C)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF005A9C), width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  addNewCategory() async {
    try {
      if (titleController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Veuillez remplir tous les champs."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      await categoryService.createCategory(titleController.text.trim());
      setState(() {
        titleController.text = "";
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      _showCategorySelector();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  deleteCategory(String id) async {
    try {
      await categoryService.deleteCategory(id);
      await fetchCategories();
      Navigator.of(context).pop();
      _showCategorySelector();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
