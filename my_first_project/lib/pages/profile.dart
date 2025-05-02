import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;

  final String userName = "Chaima Ben Amor"; // À rendre dynamique plus tard
  final String userEmail = "chaima@email.com";

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void navigateTo(int index) {
    if (index == 3) return; // Déjà sur la page profil
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/rapport');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/objectif');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? Colors.black : const Color(0xFFF5F7FB);
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C8CE7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Mon Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte Profil
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isDarkMode)
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png'),
                    radius: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: textColor.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Naviguer vers la page modification
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Modifier mon compte"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C8CE7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Options
            SwitchListTile(
              value: isDarkMode,
              onChanged: toggleDarkMode,
              secondary: Icon(Icons.nightlight_round, color: textColor),
              title: Text('Mode sombre', style: TextStyle(color: textColor)),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(Icons.chat, color: textColor),
                  const Positioned(
                    right: -2,
                    top: -2,
                    child: Icon(Icons.workspace_premium, size: 16, color: Colors.amber),
                  ),
                ],
              ),
              title: Text('Chatbot', style: TextStyle(color: textColor)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aller vers chatbot
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.help_outline, color: textColor),
              title: Text('Centre d\'aide', style: TextStyle(color: textColor)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aller vers l'aide
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Se déconnecter', style: TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
              onTap: () {
                // Action de déconnexion
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: const Color(0xFF3C8CE7),
        unselectedItemColor: Colors.grey,
        onTap: navigateTo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.chartPie), label: 'Statistiques'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Objectifs'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Compte'),
        ],
      ),
    );
  }
}
