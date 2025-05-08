import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_first_project/models/objectif.dart';
import 'package:my_first_project/services/objectif.dart';
import 'package:my_first_project/widgets/back_appbar_widget.dart';
import 'package:my_first_project/widgets/circular_widget.dart';
import 'package:my_first_project/widgets/error_message_widget.dart';

class ObjetifDetailsPage extends StatefulWidget {
  final String objectifId;
  const ObjetifDetailsPage(this.objectifId, {super.key});

  @override
  State<ObjetifDetailsPage> createState() => _ObjetifDetailsPageState();
}

class _ObjetifDetailsPageState extends State<ObjetifDetailsPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  ObjectifService objectifService = ObjectifService();
  ObjectifDetailResponse objectif = ObjectifDetailResponse(
      Objectif("", "", 0, DateTime.now(), 0, DateTime.now()), 0, 0, 0);
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      objectif = await objectifService.getObjectifDetail(widget.objectifId);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
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
      appBar: backAppBar(context, "Détails de l'Objectif"),
      body: SafeArea(
        child: isLoading
            ? CircularWidget(Colors.white)
            : errorMessage.isNotEmpty
                ? ErrorMessageWidget(errorMessage)
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Détails de l\'objectif',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildDetailTile("Nom", objectif.objectif.name),
                                buildDetailTile("Montant",
                                    "${objectif.objectif.amount.toStringAsFixed(2)} DT"),
                                buildDetailTile(
                                    "Créé le",
                                    objectif.objectif.createdAt
                                        .toLocal()
                                        .toIso8601String()
                                        .split("T")[0]),
                                buildDetailTile(
                                    "Date de fin",
                                    objectif.objectif.date
                                        .toLocal()
                                        .toIso8601String()
                                        .split("T")[0]),
                                buildDetailTile("Montant restant",
                                    "${objectif.remainingAmount.toStringAsFixed(2)} DT"),
                                buildDetailTile("Montant payé",
                                    "${objectif.objectif.progression} DT"),
                                buildDetailTile("Jours restants",
                                    objectif.remainingDays.toString()),
                                buildDetailTile("Progression",
                                    "${((objectif.objectif.progression / objectif.objectif.amount) * 100).toStringAsFixed(1)}%"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Ajouter un montant",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Form(
                              key: formKey,
                              child: Expanded(
                                flex: 2,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: amountController,
                                  decoration: inputDecoration(
                                    "Montant",
                                    FontAwesomeIcons.moneyBill1Wave,
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Champ requis";
                                    }
                                    final enteredAmount =
                                        int.tryParse(val) ?? 0;
                                    if (enteredAmount >
                                        objectif.remainingAmount) {
                                      return "Montant supérieur au montant restant";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => objectifProgress(),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: const Color(0xFF0D47A1),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          "Ajouter",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
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

  objectifProgress() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await objectifService.updateObjectifProgress(
          widget.objectifId, num.parse(amountController.text));
      fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildDetailTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
