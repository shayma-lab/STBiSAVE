import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("⚙️ Profil Administrateur", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Activer le mode sombre", style: TextStyle(fontSize: 18)),
              Switch(
                value: isDarkMode,
                activeColor: const Color(0xFF0D47A1),
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  // Ici, tu peux ajouter la logique pour changer tout le thème de l'app
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
