import 'package:flutter/material.dart';
import 'admin_users_page.dart';
import 'admin_cards_page.dart';
import 'admin_reports_page.dart';
import 'admin_profile_page.dart';

class AdminPage extends StatefulWidget {
  static const routeName = "/AdminPage";
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AdminUsersPage(),     // 👥 Page utilisateurs
    AdminCardsPage(),     // 💳 Page carte bancaire
    AdminReportsPage(),   // 📊 Page rapports
    AdminProfilePage(),   // ⚙️ Profil admin
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false, // ✅ Enlève la flèche de retour
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Espace Administrateur",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Utilisateurs"),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Cartes"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Rapports"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profil"),
        ],
      ),
    );
  }
}
