import 'package:flutter/material.dart';
import 'package:my_first_project/pages/auth/connexion.dart';
import 'package:my_first_project/pages/auth/inscription.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/HomePage";
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeIn,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: screenHeight * 0.35,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/stb_bank.png',
                      height: 130,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'STB iSAVE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B4F99),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeaderButton('Se connecter', () {
                          Navigator.pushNamed(context, LoginPage.routeName);
                        }),
                        const SizedBox(width: 15),
                        _buildHeaderButton("S'inscrire", () {
                          Navigator.pushNamed(context, InscriptionPage.routeName);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.65,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFeatureCard(
                          icon: Icons.account_balance_wallet_outlined,
                          title: "Gérer les transactions",
                          description:
                              "Suivez et gérez toutes vos transactions bancaires.",
                          color: Color(0xFF0087d4),
                        ),
                        _buildFeatureCard(
                          icon: Icons.category_outlined,
                          title: "Catégoriser les transactions",
                          description:
                              "Organisez vos dépenses par catégories (alimentation, loisirs, etc.).",
                          color: Color(0xFF0087d4),
                        ),
                        _buildFeatureCard(
                          icon: Icons.savings_outlined,
                          title: "Objectifs d'épargne",
                          description:
                              "Fixez des objectifs d'épargne et suivez vos progrès.",
                          color: Color(0xFF0087d4),
                        ),
                        _buildFeatureCard(
                          icon: Icons.bar_chart_outlined,
                          title: "Graphiques et Rapports",
                          description:
                              "Consultez des graphiques interactifs et des rapports détaillés.",
                          color: Color(0xFF0087d4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF0B4F99)),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0B4F99),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 30);
    path.quadraticBezierTo(
      size.width / 4,
      0,
      size.width / 2,
      20,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      40,
      size.width,
      20,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
