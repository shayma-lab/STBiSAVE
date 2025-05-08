import 'package:flutter/material.dart';
import 'package:my_first_project/models/user.dart';
import 'package:my_first_project/pages/client/profile.dart';
import 'package:my_first_project/services/auth.dart';
import 'package:my_first_project/widgets/back_appbar_widget.dart';

class ModifyProfilePage extends StatefulWidget {
  final UserData user;
  const ModifyProfilePage(this.user, {super.key});

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final prenomController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();
  bool isLoading = false;

  String? selectedCivilite;
  String? selectedGouvernorat;

  List<String> gouvernorats = [
    "Tunis",
    "Ariana",
    "Ben Arous",
    "Manouba",
    "Nabeul",
    "Zaghouan",
    "Bizerte",
    "Béja",
    "Jendouba",
    "Kef",
    "Siliana",
    "Sousse",
    "Monastir",
    "Mahdia",
    "Kairouan",
    "Kasserine",
    "Sidi Bouzid",
    "Sfax",
    "Gabès",
    "Médenine",
    "Tataouine",
    "Gafsa",
    "Tozeur",
    "Kebili"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toIso8601String().split("T")[0];
      });
    }
  }

  InputDecoration _inputDecoration(String hintText, IconData icon) {
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

  @override
  void initState() {
    super.initState();
    setData();
  }

  Future<void> setData() async {
    setState(() {
      nameController.text = widget.user.name;
      prenomController.text = widget.user.prenom;
      phoneController.text = widget.user.phone;
      dateController.text =
          widget.user.dateNaissance.toIso8601String().split("T")[0];
      selectedCivilite = widget.user.civilite;
      selectedGouvernorat = widget.user.gouvernorat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(context, "Modifier le profil"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration:
                      _inputDecoration("Civilité", Icons.person_outline),
                  value: selectedCivilite,
                  onChanged: (val) => setState(() => selectedCivilite = val),
                  items: ["M.", "Mme"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  validator: (val) => val == null ? "Champ requis" : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: _inputDecoration("Nom", Icons.badge),
                        validator: (val) =>
                            val!.isEmpty ? "Champ requis" : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: prenomController,
                        decoration:
                            _inputDecoration("Prénom", Icons.badge_outlined),
                        validator: (val) =>
                            val!.isEmpty ? "Champ requis" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: _inputDecoration("Téléphone", Icons.phone),
                  validator: (val) => val!.isEmpty ? "Champ requis" : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration(
                      "Gouvernorat", Icons.location_on_outlined),
                  value: selectedGouvernorat,
                  onChanged: (val) => setState(() => selectedGouvernorat = val),
                  items: gouvernorats
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  validator: (val) => val == null ? "Champ requis" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: _inputDecoration(
                      "Date de naissance", Icons.calendar_today_outlined),
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
                      onTap: _submitForm,
                      child: const Center(
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
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        Auth auth = Auth();
        await auth.updateUser(
          nameController.text,
          prenomController.text,
          phoneController.text,
          selectedCivilite ?? "M.",
          selectedGouvernorat ?? "Tunis",
          DateTime.parse(dateController.text),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil modifié avec succès")),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de modification : $e")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
