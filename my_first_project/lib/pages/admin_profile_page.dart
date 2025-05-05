import 'package:flutter/material.dart';
import 'package:my_first_project/services/auth.dart';
import 'package:my_first_project/widgets/yes_or_no_popup.dart';

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
          const Text("⚙️ Profil Administrateur",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Activer le mode sombre",
                  style: TextStyle(fontSize: 18)),
              Switch(
                value: isDarkMode,
                activeColor: const Color(0xFF0D47A1),
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Se déconnecter',
                style: TextStyle(color: Colors.red)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.red),
            onTap: logout,
          ),
        ],
      ),
    );
  }

  logout() async {
    showDialog(
      context: context,
      builder: (context) => YesOrNoPopup(
          "Déconnexion", "Êtes-vous sûr de vouloir vous déconnecter ?",
          () async {
        Auth auth = Auth();
        await auth.logout(context);
      }),
    );
  }
}
