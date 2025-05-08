import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_first_project/models/objectif.dart';
import 'package:my_first_project/services/objectif.dart';
import 'package:my_first_project/widgets/back_appbar_widget.dart';
import 'package:my_first_project/widgets/circular_widget.dart';

class UpdateObjectifPage extends StatefulWidget {
  static const routeName = "/UpdateObjectifPage";
  final Objectif objectif;
  const UpdateObjectifPage(this.objectif, {super.key});

  @override
  State<UpdateObjectifPage> createState() => _UpdateObjectifPageState();
}

class _UpdateObjectifPageState extends State<UpdateObjectifPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.objectif.name;
    amountController.text = widget.objectif.amount.toStringAsFixed(2);
    dateController.text = widget.objectif.date.toIso8601String().split("T")[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(context, "Modifier un Objectif"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Modifier cette objectif',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: inputDecoration(
                          "Objectif", FontAwesomeIcons.objectGroup),
                      validator: (val) => val!.isEmpty ? "Champ requis" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: amountController,
                      decoration: inputDecoration(
                          "Montant", FontAwesomeIcons.moneyBill1Wave),
                      validator: (val) => val!.isEmpty ? "Champ requis" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () => selectDate(context),
                      decoration: inputDecoration(
                          "Date final", Icons.calendar_today_outlined),
                      validator: (val) => val!.isEmpty ? "Champ requis" : null,
                    ),
                    const SizedBox(height: 30),
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
                          onTap: isLoading ? null : addObjectif,
                          child: isLoading
                              ? CircularWidget(Colors.white)
                              : Center(
                                  child: Text(
                                    "Modifier",
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
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF005A9C)),
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toIso8601String().split("T")[0];
      });
    }
  }

  Future<void> addObjectif() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veuillez remplir tous les champs."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => isLoading = true);
    ObjectifService objectifService = ObjectifService();
    try {
      await objectifService.updateObjectif(
          widget.objectif.id,
          nameController.text.trim(),
          num.parse(amountController.text),
          DateTime.parse(dateController.text));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
