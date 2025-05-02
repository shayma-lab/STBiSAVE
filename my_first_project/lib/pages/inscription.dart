import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();

  String? selectedCivilite;
  String? selectedGouvernorat;

  List<String> gouvernorats = [
    "Tunis", "Ariana", "Ben Arous", "Manouba", "Nabeul", "Zaghouan", "Bizerte", "Béja",
    "Jendouba", "Kef", "Siliana", "Sousse", "Monastir", "Mahdia", "Kairouan", "Kasserine",
    "Sidi Bouzid", "Sfax", "Gabès", "Médenine", "Tataouine", "Gafsa", "Tozeur", "Kebili"
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://localhost:5000/api/auth/signup');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text,
          "prenom": prenomController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "phone": phoneController.text,
          "civilite": selectedCivilite,
          "gouvernorat": selectedGouvernorat,
          "dateNaissance": dateController.text,
        }),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inscription réussie")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse["msg"] ?? "Erreur inconnue")),
        );
      }
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ShaderMask(
  shaderCallback: (bounds) => const LinearGradient(
    colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(bounds),
  child: const Text(
    'STB iSAVE',
    style: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Colors.white, // La couleur ici sera masquée par le shader
      letterSpacing: 1.5,
    ),
  ),
),
const SizedBox(height: 8),
const Text(
  "Créez votre compte et commencez à économiser",
  style: TextStyle(
    fontSize: 16,
    color: Colors.black87,
  ),
  textAlign: TextAlign.center,
),
const SizedBox(height: 30),


                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Civilité", Icons.person_outline),
                    value: selectedCivilite,
                    onChanged: (val) => setState(() => selectedCivilite = val),
                    items: ["M.", "Mme"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    validator: (val) => val == null ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: nameController,
                          decoration: _inputDecoration("Nom", Icons.badge),
                          validator: (val) => val!.isEmpty ? "Champ requis" : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: prenomController,
                          decoration: _inputDecoration("Prénom", Icons.badge_outlined),
                          validator: (val) => val!.isEmpty ? "Champ requis" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration("Email", Icons.email_outlined),
                    validator: (val) => val!.isEmpty ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Mot de passe", Icons.lock_outline),
                    validator: (val) => val!.length < 6 ? "Min 6 caractères" : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: phoneController,
                    decoration: _inputDecoration("Téléphone", Icons.phone),
                    validator: (val) => val!.isEmpty ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Gouvernorat", Icons.location_on_outlined),
                    value: selectedGouvernorat,
                    onChanged: (val) => setState(() => selectedGouvernorat = val),
                    items: gouvernorats.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    validator: (val) => val == null ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: _inputDecoration("Date de naissance", Icons.calendar_today_outlined),
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
          "S'inscrire",
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

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Déjà un compte ? Se connecter",
                      style: TextStyle(color: Color(0xFF0D47A1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
