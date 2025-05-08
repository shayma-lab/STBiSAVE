import 'package:flutter/material.dart';
import 'package:my_first_project/models/user.dart';
import 'package:my_first_project/pages/client/acceuil.dart';
import 'package:my_first_project/pages/client/modify_profile_page.dart';
import 'package:my_first_project/pages/client/rapport.dart';
import 'package:my_first_project/services/auth.dart';
import 'package:my_first_project/widgets/appbar_widget.dart';
import 'package:my_first_project/widgets/yes_or_no_popup.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/ProfilePage";
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;
  UserData user = UserData("", "", "", "", "", "", DateTime.now(), 0, []);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Auth auth = Auth();
    final userData = await auth.userData();
    setState(() {
      user = userData;
    });
  }

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void navigateTo(int index) {
    if (index == 3) return; // Déjà sur la page profil
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AcceuilPage.routeName);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, RapportsPage.routeName);
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
      appBar: appBar(context, "Mon Profil"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                      radius: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${user.civilite} ${user.name} ${user.prenom}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.dateNaissance.toIso8601String().split("T")[0],
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phone,
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifyProfilePage(user),
                            ));
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
                      child: Icon(Icons.workspace_premium,
                          size: 16, color: Colors.amber),
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
                title:
                    Text('Centre d\'aide', style: TextStyle(color: textColor)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Aller vers l'aide
                },
              ),
              const SizedBox(height: 10),
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
        ),
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
